import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../widgets/product_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with SingleTickerProviderStateMixin {
  final ProductService _productService = ProductService();
  late TabController _tabController;
  
  List<ProductModel> _featuredProducts = [];
  List<ProductModel> _onSaleProducts = [];
  List<ProductModel> _allProducts = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      // Crear productos de ejemplo para demostración
      final sampleProducts = _createSampleProducts();
      
      setState(() {
        _featuredProducts = sampleProducts.where((p) => p.isFeatured).toList();
        _onSaleProducts = sampleProducts.where((p) => p.isOnSale).toList();
        _allProducts = sampleProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar productos: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  List<ProductModel> _createSampleProducts() {
    final now = DateTime.now();
    return [
      ProductModel(
        id: '1',
        name: 'Laptop Gaming Pro',
        description: 'Laptop de alta gama para gaming y trabajo profesional',
        price: 1299.99,
        images: ['https://via.placeholder.com/300x200'],
        category: 'Electrónicos',
        subcategory: 'Computadoras',
        type: ProductType.product,
        sellerId: 'seller1',
        sellerCompanyId: 'company1',
        sellerName: 'TechStore',
        sellerCompanyName: 'TechStore S.A.',
        stock: 15,
        rating: 4.8,
        totalReviews: 124,
        createdAt: now,
        updatedAt: now,
        isFeatured: true,
        isVerified: true,
        discountPercentage: 15.0,
        shippingInfo: ShippingInfo(freeShipping: true),
        dimensions: ProductDimensions(),
      ),
      ProductModel(
        id: '2',
        name: 'Smartphone Ultra',
        description: 'Smartphone con cámara profesional y batería de larga duración',
        price: 899.99,
        images: ['https://via.placeholder.com/300x200'],
        category: 'Electrónicos',
        subcategory: 'Smartphones',
        type: ProductType.product,
        sellerId: 'seller2',
        sellerCompanyId: 'company2',
        sellerName: 'MobileWorld',
        sellerCompanyName: 'MobileWorld Inc.',
        stock: 25,
        rating: 4.6,
        totalReviews: 89,
        createdAt: now,
        updatedAt: now,
        isFeatured: false,
        isVerified: true,
        discountPercentage: 10.0,
        shippingInfo: ShippingInfo(freeShipping: true),
        dimensions: ProductDimensions(),
      ),
      ProductModel(
        id: '3',
        name: 'Camiseta Premium',
        description: 'Camiseta de algodón 100% orgánico, cómoda y duradera',
        price: 29.99,
        images: ['https://via.placeholder.com/300x200'],
        category: 'Ropa y Accesorios',
        subcategory: 'Ropa Masculina',
        type: ProductType.product,
        sellerId: 'seller3',
        sellerCompanyId: 'company3',
        sellerName: 'FashionHub',
        sellerCompanyName: 'FashionHub Ltd.',
        stock: 50,
        rating: 4.4,
        totalReviews: 67,
        createdAt: now,
        updatedAt: now,
        isFeatured: true,
        isVerified: false,
        shippingInfo: ShippingInfo(shippingCost: 5.99),
        dimensions: ProductDimensions(),
      ),
      ProductModel(
        id: '4',
        name: 'Consultoría Empresarial',
        description: 'Servicio de consultoría para optimización de procesos empresariales',
        price: 150.0,
        images: ['https://via.placeholder.com/300x200'],
        category: 'Servicios Profesionales',
        subcategory: 'Consultoría',
        type: ProductType.service,
        sellerId: 'seller4',
        sellerCompanyId: 'company4',
        sellerName: 'ConsultPro',
        sellerCompanyName: 'ConsultPro Solutions',
        hasUnlimitedStock: true,
        rating: 4.9,
        totalReviews: 156,
        createdAt: now,
        updatedAt: now,
        isFeatured: false,
        isVerified: true,
        shippingInfo: ShippingInfo(freeShipping: true),
        dimensions: ProductDimensions(),
      ),
    ];
  }

  Future<void> _searchProducts() async {
    if (_searchQuery.isEmpty && _selectedCategory == null) {
      _loadProducts();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final allSampleProducts = _createSampleProducts();
      List<ProductModel> filteredProducts = allSampleProducts;

      if (_searchQuery.isNotEmpty) {
        filteredProducts = filteredProducts.where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();
      }

      if (_selectedCategory != null) {
        filteredProducts = filteredProducts.where((product) =>
          product.category == _selectedCategory
        ).toList();
      }

      setState(() {
        _allProducts = filteredProducts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en la búsqueda: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (_) => _searchProducts(),
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: _showFilterDialog,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: const [
                  Tab(text: 'Destacados'),
                  Tab(text: 'Ofertas'),
                  Tab(text: 'Todos'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid(_featuredProducts),
                _buildProductGrid(_onSaleProducts),
                _buildProductGrid(_allProducts),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar a crear producto
        },
        backgroundColor: AppTheme.accentOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Publicar'),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No hay productos disponibles',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onAddToCart: () {
              // TODO: Implementar agregar al carrito
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${products[index].name} agregado al carrito'),
                  backgroundColor: AppTheme.trustGreen,
                ),
              );
            },
            onFavorite: () {
              // TODO: Implementar favoritos
            },
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtros'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Todas las categorías'),
                ),
                ...ProductCategories.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _searchQuery = '';
              });
              Navigator.of(context).pop();
              _loadProducts();
            },
            child: const Text('Limpiar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _searchProducts();
            },
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
