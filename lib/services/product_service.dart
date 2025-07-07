import '../models/product_model.dart';
import 'local_database_service.dart';

class ProductService {
  final String _boxName = 'productsBox';

  // Crear un nuevo producto
  Future<ProductModel> createProduct(ProductModel product) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    final key = await box.add(product);
    return product.copyWith(id: key.toString());
  }

  // Obtener un producto por ID
  Future<ProductModel?> getProductById(String id) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    return box.values.firstWhere((p) => p.id == id, orElse: () => null);
  }

  // Ajustar métodos que devuelven List<dynamic> a List<ProductModel>
  Future<List<ProductModel>> getProductsBySeller(String sellerId) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    return List<ProductModel>.from(box.values.where((p) => p.sellerId == sellerId));
  }

  Future<List<ProductModel>> getProductsByCompany(String companyId) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    return List<ProductModel>.from(box.values.where((p) => p.sellerCompanyId == companyId));
  }

  // Actualizar un producto
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    final idx = box.values.toList().indexWhere((p) => p.id == id);
    if (idx != -1) {
      final product = box.getAt(idx);
      if (product != null) {
        final updated = product.copyWith(
          // ...aplica los cambios de data manualmente según tu modelo
        );
        await box.putAt(idx, updated);
      }
    }
  }

  // Eliminar un producto
  Future<void> deleteProduct(String id) async {
    final box = await LocalDatabaseService.openBox(_boxName);
    final idx = box.values.toList().indexWhere((p) => p.id == id);
    if (idx != -1) await box.deleteAt(idx);
  }

  // Métodos de búsqueda, destacados, relacionados, etc. pueden implementarse localmente filtrando box.values
  // ...
}
