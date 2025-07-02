import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();

  // Crear una nueva orden desde el carrito
  Future<OrderModel> createOrder({
    required String userId,
    required String userName,
    required String userEmail,
    required ShippingAddress shippingAddress,
    required PaymentInfo paymentInfo,
    String? notes,
  }) async {
    try {
      // Obtener carrito actual
      final cart = await _cartService.getUserCart(userId);
      if (cart == null || cart.isEmpty) {
        throw Exception('El carrito está vacío');
      }

      // Validar items del carrito
      final validationErrors = await _cartService.validateCartItems(userId);
      if (validationErrors.isNotEmpty) {
        throw Exception('Algunos productos no están disponibles: ${validationErrors.values.join(', ')}');
      }

      // Crear la orden
      final now = DateTime.now();
      final order = OrderModel(
        id: '',
        buyerId: userId,
        buyerName: userName,
        buyerEmail: userEmail,
        items: cart.items.map((item) => OrderItem(
          productId: item.productId,
          productName: item.productName,
          productImage: item.productImage,
          unitPrice: item.unitPrice,
          quantity: item.quantity,
          variantId: item.variantId,
          variantName: item.variantName,
          sellerId: item.sellerId,
          sellerName: item.sellerName,
          sellerCompanyId: item.sellerCompanyId,
          sellerCompanyName: item.sellerCompanyName,
        )).toList(),
        subtotal: cart.subtotal,
        shippingCost: cart.shippingCost,
        totalDiscount: cart.totalDiscount,
        total: cart.total,
        currency: cart.currency,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.pending,
        shippingStatus: ShippingStatus.pending,
        createdAt: now,
        updatedAt: now,
        shippingAddress: shippingAddress,
        paymentInfo: paymentInfo,
        notes: notes,
      );

      // Guardar la orden
      final docRef = await _firestore.collection(_collection).add(order.toMap());
      final newOrder = order.copyWith(id: docRef.id);

      // Actualizar stock de productos
      await _updateProductStock(newOrder.items);

      // Limpiar carrito
      await _cartService.clearCart(userId);

      return newOrder;
    } catch (e) {
      throw Exception('Error al crear la orden: $e');
    }
  }

  // Actualizar stock de productos
  Future<void> _updateProductStock(List<OrderItem> items) async {
    try {
      for (final item in items) {
        final product = await _productService.getProductById(item.productId);
        if (product == null) continue;

        if (item.variantId != null) {
          // Actualizar stock de variante
          final variant = product.variants
              .firstWhere((v) => v.id == item.variantId);
          
          await _productService.updateProduct(
            product.id,
            {
              'variants': product.variants.map((v) {
                if (v.id == item.variantId) {
                  return {
                    ...v.toMap(),
                    'stock': v.stock - item.quantity,
                  };
                }
                return v.toMap();
              }).toList(),
            },
          );
        } else {
          // Actualizar stock principal
          await _productService.updateStock(
            product.id,
            product.stock - item.quantity,
          );
        }

        // Incrementar ventas totales
        await _productService.incrementSales(product.id);
      }
    } catch (e) {
      throw Exception('Error al actualizar stock: $e');
    }
  }

  // Obtener orden por ID
  Future<OrderModel?> getOrderById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return OrderModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener la orden: $e');
    }
  }

  // Obtener órdenes del usuario
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('buyerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return query.docs
          .map((doc) => OrderModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener órdenes del usuario: $e');
    }
  }

  // Obtener órdenes del vendedor
  Future<List<OrderModel>> getSellerOrders(String sellerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('items', arrayContains: {'sellerId': sellerId})
          .orderBy('createdAt', descending: true)
          .get();
      
      return query.docs
          .map((doc) => OrderModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener órdenes del vendedor: $e');
    }
  }

  // Actualizar estado de la orden
  Future<void> updateOrderStatus({
    required String orderId,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    ShippingStatus? shippingStatus,
    String? trackingNumber,
    DateTime? estimatedDelivery,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (status != null) {
        updates['status'] = status.toString();
      }

      if (paymentStatus != null) {
        updates['paymentStatus'] = paymentStatus.toString();
      }

      if (shippingStatus != null) {
        updates['shippingStatus'] = shippingStatus.toString();
      }

      if (trackingNumber != null) {
        updates['trackingNumber'] = trackingNumber;
      }

      if (estimatedDelivery != null) {
        updates['estimatedDelivery'] = estimatedDelivery.toIso8601String();
      }

      await _firestore.collection(_collection).doc(orderId).update(updates);
    } catch (e) {
      throw Exception('Error al actualizar estado de la orden: $e');
    }
  }

  // Cancelar orden
  Future<void> cancelOrder(String orderId) async {
    try {
      final order = await getOrderById(orderId);
      if (order == null) {
        throw Exception('Orden no encontrada');
      }

      // Verificar si la orden puede ser cancelada
      if (order.status == OrderStatus.delivered ||
          order.status == OrderStatus.cancelled ||
          order.status == OrderStatus.refunded) {
        throw Exception('La orden no puede ser cancelada en su estado actual');
      }

      // Restaurar stock de productos
      await _restoreProductStock(order.items);

      // Actualizar estado de la orden
      await updateOrderStatus(
        orderId: orderId,
        status: OrderStatus.cancelled,
      );
    } catch (e) {
      throw Exception('Error al cancelar la orden: $e');
    }
  }

  // Restaurar stock de productos
  Future<void> _restoreProductStock(List<OrderItem> items) async {
    try {
      for (final item in items) {
        final product = await _productService.getProductById(item.productId);
        if (product == null) continue;

        if (item.variantId != null) {
          // Restaurar stock de variante
          final variant = product.variants
              .firstWhere((v) => v.id == item.variantId);
          
          await _productService.updateProduct(
            product.id,
            {
              'variants': product.variants.map((v) {
                if (v.id == item.variantId) {
                  return {
                    ...v.toMap(),
                    'stock': v.stock + item.quantity,
                  };
                }
                return v.toMap();
              }).toList(),
            },
          );
        } else {
          // Restaurar stock principal
          await _productService.updateStock(
            product.id,
            product.stock + item.quantity,
          );
        }
      }
    } catch (e) {
      throw Exception('Error al restaurar stock: $e');
    }
  }

  // Stream de órdenes del usuario para actualizaciones en tiempo real
  Stream<List<OrderModel>> watchUserOrders(String userId) {
    return _firestore
        .collection(_collection)
        .where('buyerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }
}
