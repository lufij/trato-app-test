import '../models/cart_model.dart';
import '../models/product_model.dart';
import 'local_database_service.dart';

class CartService {
  final String _boxName = 'cartsBox';

  // Obtener carrito del usuario
  Future<CartModel?> getUserCart(String userId) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    return box.values.firstWhere((c) => c.userId == userId, orElse: () => null);
  }

  // Crear carrito para usuario
  Future<CartModel> createCart(String userId) async {
    final now = DateTime.now();
    final cart = CartModel(
      id: '',
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );
    final box = await LocalDatabaseService.openBox(_boxName);
    final key = await box.add(cart);
    return cart.copyWith(id: key.toString());
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

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(items: updatedItems));
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

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(items: updatedItems));
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

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(items: updatedItems));
    } catch (e) {
      throw Exception('Error al remover del carrito: $e');
    }
  }

  // Limpiar carrito
  Future<void> clearCart(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(items: []));
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

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(couponCode: couponCode, couponDiscount: discount));
    } catch (e) {
      throw Exception('Error al aplicar cupón: $e');
    }
  }

  // Remover cupón
  Future<void> removeCoupon(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return;

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(couponCode: null, couponDiscount: 0.0));
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

      final box = await LocalDatabaseService.openBox(_boxName);
      await box.put(cart.id, cart.copyWith(shippingCost: shippingCost));
    } catch (e) {
      throw Exception('Error al actualizar costo de envío: $e');
    }
  }

  // Validar disponibilidad de productos en el carrito (versión local simplificada)
  Future<Map<String, String>> validateCartItems(String userId) async {
    try {
      final cart = await getUserCart(userId);
      if (cart == null) return {};
      Map<String, String> errors = {};
      // Aquí deberías validar contra los productos locales en Hive
      // Por ejemplo, podrías abrir la caja de productos y verificar existencia y stock
      // Este método queda como TODO para lógica local
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
