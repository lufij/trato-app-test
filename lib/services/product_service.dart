import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Crear un nuevo producto
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final docRef = await _firestore.collection(_collection).add(product.toMap());
      return product.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Error al crear el producto: $e');
    }
  }

  // Obtener un producto por ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return ProductModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el producto: $e');
    }
  }

  // Obtener productos por vendedor
  Future<List<ProductModel>> getProductsBySeller(String sellerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('sellerId', isEqualTo: sellerId)
          .get();
      
      return query.docs
          .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos del vendedor: $e');
    }
  }

  // Obtener productos por empresa
  Future<List<ProductModel>> getProductsByCompany(String companyId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('sellerCompanyId', isEqualTo: companyId)
          .get();
      
      return query.docs
          .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos de la empresa: $e');
    }
  }

  // Actualizar un producto
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar el producto: $e');
    }
  }

  // Eliminar un producto
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar el producto: $e');
    }
  }

  // Actualizar stock
  Future<void> updateStock(String id, int newStock) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'stock': newStock,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar el stock: $e');
    }
  }

  // Buscar productos
  Future<List<ProductModel>> searchProducts({
    String? query,
    String? category,
    String? subcategory,
    ProductType? type,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
    bool? onSale,
    String? sellerId,
    String? sellerCompanyId,
    int limit = 20,
  }) async {
    try {
      Query productsQuery = _firestore.collection(_collection);

      if (query != null && query.isNotEmpty) {
        // Implementar búsqueda por texto (requiere configuración de índices)
        productsQuery = productsQuery.where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: '${query}z');
      }

      if (category != null) {
        productsQuery = productsQuery.where('category', isEqualTo: category);
      }

      if (subcategory != null) {
        productsQuery = productsQuery.where('subcategory', isEqualTo: subcategory);
      }

      if (type != null) {
        productsQuery = productsQuery.where('type', isEqualTo: type.toString());
      }

      if (sellerId != null) {
        productsQuery = productsQuery.where('sellerId', isEqualTo: sellerId);
      }

      if (sellerCompanyId != null) {
        productsQuery = productsQuery.where('sellerCompanyId', isEqualTo: sellerCompanyId);
      }

      if (inStock == true) {
        productsQuery = productsQuery.where('stock', isGreaterThan: 0);
      }

      if (onSale == true) {
        productsQuery = productsQuery.where('discountPercentage', isGreaterThan: 0);
      }

      productsQuery = productsQuery.limit(limit);

      final querySnapshot = await productsQuery.get();
      
      List<ProductModel> products = querySnapshot.docs
          .map((doc) => ProductModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();

      // Filtros que no se pueden hacer directamente en la query
      if (minPrice != null || maxPrice != null) {
        products = products.where((product) {
          final price = product.finalPrice;
          if (minPrice != null && price < minPrice) return false;
          if (maxPrice != null && price > maxPrice) return false;
          return true;
        }).toList();
      }

      return products;
    } catch (e) {
      throw Exception('Error al buscar productos: $e');
    }
  }

  // Obtener productos destacados
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('isFeatured', isEqualTo: true)
          .limit(limit)
          .get();
      
      return query.docs
          .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos destacados: $e');
    }
  }

  // Obtener productos en oferta
  Future<List<ProductModel>> getProductsOnSale({int limit = 10}) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('discountPercentage', isGreaterThan: 0)
          .limit(limit)
          .get();
      
      return query.docs
          .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos en oferta: $e');
    }
  }

  // Obtener productos por categoría
  Future<List<ProductModel>> getProductsByCategory(
    String category, {
    String? subcategory,
    int limit = 20,
  }) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('category', isEqualTo: category);

      if (subcategory != null) {
        query = query.where('subcategory', isEqualTo: subcategory);
      }

      query = query.limit(limit);

      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => ProductModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener productos por categoría: $e');
    }
  }

  // Obtener productos relacionados
  Future<List<ProductModel>> getRelatedProducts(
    ProductModel product, {
    int limit = 10,
  }) async {
    try {
      // Primero intentamos por la misma subcategoría
      var query = await _firestore
          .collection(_collection)
          .where('subcategory', isEqualTo: product.subcategory)
          .where('id', isNotEqualTo: product.id)
          .limit(limit)
          .get();

      List<ProductModel> relatedProducts = query.docs
          .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();

      // Si no hay suficientes, completamos con productos de la misma categoría
      if (relatedProducts.length < limit) {
        query = await _firestore
            .collection(_collection)
            .where('category', isEqualTo: product.category)
            .where('id', isNotEqualTo: product.id)
            .limit(limit - relatedProducts.length)
            .get();

        relatedProducts.addAll(
          query.docs
              .map((doc) => ProductModel.fromMap({...doc.data(), 'id': doc.id}))
              .where((p) => !relatedProducts.any((rp) => rp.id == p.id))
              .toList(),
        );
      }

      return relatedProducts;
    } catch (e) {
      throw Exception('Error al obtener productos relacionados: $e');
    }
  }

  // Incrementar total de ventas
  Future<void> incrementSales(String productId) async {
    try {
      await _firestore.collection(_collection).doc(productId).update({
        'totalSales': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al incrementar ventas: $e');
    }
  }

  // Actualizar calificación
  Future<void> updateRating(String productId, double newRating, int newTotalReviews) async {
    try {
      await _firestore.collection(_collection).doc(productId).update({
        'rating': newRating,
        'totalReviews': newTotalReviews,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar calificación: $e');
    }
  }
}
