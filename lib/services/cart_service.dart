import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'carts';

  // Obtener carrito del usuario
  Future<CartModel?> getUserCart(String userId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        return CartModel.fromMap({
          ...query.docs.first.data(),
          'id': query.docs.first.id
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el carrito: $e');
    }
  }

  // Crear carrito para usuario
  Future<CartModel> createCart(String userId) async {
    try {
      final now = DateTime.now();
      final cart = CartModel(
        id: '',
        userId: userId,
        createdAt: now,
        updatedAt: now,
      );
      
      final docRef = await _firestore.collection(_collection).add(cart.toMap());
      return cart.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Error al crear el carrito: $e');
    }
  }

  // Agregar item al carrito
  Future<void> addToCart({
    required String userId,
    required ProductModel product,
    required int quantity,
    String? variantId,
  }) async {
    try {
      CartModel? cart = await getUserCart(userId);
      
      // Si no existe carrito, crear uno
      cart ??= await createCart(userId);

      final cartItem = CartItem(
        productId: product.id,
        productName: product.name,
        productImage: product.images.isNotEmpty ? product.images.first : '',
        unitPrice: product.finalPrice,
        quantity: quantity,
        variantId: variantId,
        variantName: variantId != null 
            ? product.variants.firstWhere((v) => v.id == variantId).name 
            : null,
        sellerId: product.sellerId,
        sellerName: product.sellerName,
        sellerCompanyId: product.sellerCompanyId,
        sellerCompanyName: product.sellerCompanyName,
        addedAt: DateTime.now(),
        productData: product.toMap(),
      );

      // Verificar si el item ya existe
      final existingItemIndex = cart.items.indexWhere(
        (item) => item.productId == product.id && item.variantId == variantId,
      );

      List<CartItem> updatedItems = List.from(cart.items);
      
      if (existingItemIndex >= 0) {
        // Actualizar cantidad del item existente
        updatedItems[existingItemIndex] = updatedItems[existingItemIndex]
            .copyWith(quantity: updatedItems[existingItemIndex].quantity + quantity);
      } else {
        // Agregar nuevo item
        updatedItems.add(cartItem);
      }

      await _firestore.collection(_collection).doc(cart.id).update({
        'items': updatedItems.map((item) => item.toMap()).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al agregar al carrito: $e');
    }
  }

  // Actualizar cantidad de item
  Future<void> updateItemQuantity({
    required String userId,
    required String productId,
    String? variantId,
    required int newQuantity,
  }) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      List<CartItem> updatedItems = cart.items.map((item) {
        if (item.productId == productId && item.variantId == variantId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList();

      await _firestore.collection(_collection).doc(cart.id).update({
        'items': updatedItems.map((item) => item.toMap()).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar cantidad: $e');
    }
  }

  // Remover item del carrito
  Future<void> removeFromCart({
    required String userId,
    required String productId,
    String? variantId,
  }) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      List<CartItem> updatedItems = cart.items
          .where((item) => !(item.productId == productId && item.variantId == variantId))
          .toList();

      await _firestore.collection(_collection).doc(cart.id).update({
        'items': updatedItems.map((item) => item.toMap()).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al remover del carrito: $e');
    }
  }

  // Limpiar carrito
  Future<void> clearCart(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      await _firestore.collection(_collection).doc(cart.id).update({
        'items': [],
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al limpiar carrito: $e');
    }
  }

  // Aplicar cupón
  Future<void> applyCoupon({
    required String userId,
    required String couponCode,
    required double discount,
  }) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      await _firestore.collection(_collection).doc(cart.id).update({
        'couponCode': couponCode,
        'couponDiscount': discount,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al aplicar cupón: $e');
    }
  }

  // Remover cupón
  Future<void> removeCoupon(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      await _firestore.collection(_collection).doc(cart.id).update({
        'couponCode': null,
        'couponDiscount': 0.0,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al remover cupón: $e');
    }
  }

  // Actualizar costo de envío
  Future<void> updateShippingCost({
    required String userId,
    required double shippingCost,
  }) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      await _firestore.collection(_collection).doc(cart.id).update({
        'shippingCost': shippingCost,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar costo de envío: $e');
    }
  }

  // Stream del carrito para actualizaciones en tiempo real
  Stream<CartModel?> watchUserCart(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return CartModel.fromMap({
          ...snapshot.docs.first.data(),
          'id': snapshot.docs.first.id
        });
      }
      return null;
    });
  }

  // Validar disponibilidad de productos en el carrito
  Future<Map<String, String>> validateCartItems(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return {};

      Map<String, String> errors = {};

      for (final item in cart.items) {
        final productDoc = await _firestore
            .collection('products')
            .doc(item.productId)
            .get();

        if (!productDoc.exists) {
          errors[item.productId] = 'Producto no disponible';
          continue;
        }

        final product = ProductModel.fromMap({
          ...productDoc.data()!,
          'id': productDoc.id
        });

        if (product.status != ProductStatus.active) {
          errors[item.productId] = 'Producto no activo';
          continue;
        }

        if (!product.hasUnlimitedStock && product.stock < item.quantity) {
          errors[item.productId] = 'Stock insuficiente (disponible: ${product.stock})';
          continue;
        }

        if (item.variantId != null) {
          final variant = product.variants
              .where((v) => v.id == item.variantId)
              .firstOrNull;
          
          if (variant == null) {
            errors[item.productId] = 'Variante no disponible';
            continue;
          }

          if (variant.stock < item.quantity) {
            errors[item.productId] = 'Stock insuficiente para variante (disponible: ${variant.stock})';
            continue;
          }
        }
      }

      return errors;
    } catch (e) {
      throw Exception('Error al validar carrito: $e');
    }
  }

  // Obtener resumen del carrito
  Future<CartSummary> getCartSummary(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) {
        return CartSummary(
          subtotal: 0.0,
          discount: 0.0,
          shippingCost: 0.0,
          total: 0.0,
          itemCount: 0,
        );
      }

      return CartSummary(
        subtotal: cart.subtotal,
        discount: cart.totalDiscount,
        shippingCost: cart.shippingCost,
        total: cart.total,
        itemCount: cart.totalItems,
      );
    } catch (e) {
      throw Exception('Error al obtener resumen del carrito: $e');
    }
  }
}

class CartSummary {
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double total;
  final int itemCount;

  CartSummary({
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.total,
    required this.itemCount,
  });
}

extension on Iterable<ProductVariant> {
  ProductVariant? get firstOrNull {
    return isEmpty ? null : first;
  }
}
