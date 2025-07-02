class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> images;
  final String category;
  final String subcategory;
  final ProductType type;
  final ProductStatus status;
  final String sellerId;
  final String sellerCompanyId;
  final String sellerName;
  final String sellerCompanyName;
  final int stock;
  final bool hasUnlimitedStock;
  final List<String> tags;
  final Map<String, dynamic> specifications;
  final double rating;
  final int totalReviews;
  final int totalSales;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
  final bool isVerified;
  final double? discountPercentage;
  final double? originalPrice;
  final DateTime? discountEndDate;
  final String? videoUrl;
  final List<ProductVariant> variants;
  final ShippingInfo shippingInfo;
  final String? sku;
  final double weight;
  final ProductDimensions dimensions;
  final List<String> relatedProducts;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'USD',
    this.images = const [],
    required this.category,
    this.subcategory = '',
    required this.type,
    this.status = ProductStatus.active,
    required this.sellerId,
    required this.sellerCompanyId,
    required this.sellerName,
    required this.sellerCompanyName,
    this.stock = 0,
    this.hasUnlimitedStock = false,
    this.tags = const [],
    this.specifications = const {},
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalSales = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.isVerified = false,
    this.discountPercentage,
    this.originalPrice,
    this.discountEndDate,
    this.videoUrl,
    this.variants = const [],
    required this.shippingInfo,
    this.sku,
    this.weight = 0.0,
    required this.dimensions,
    this.relatedProducts = const [],
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      type: ProductType.values.firstWhere(
        (type) => type.toString() == map['type'],
        orElse: () => ProductType.product,
      ),
      status: ProductStatus.values.firstWhere(
        (status) => status.toString() == map['status'],
        orElse: () => ProductStatus.active,
      ),
      sellerId: map['sellerId'] ?? '',
      sellerCompanyId: map['sellerCompanyId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerCompanyName: map['sellerCompanyName'] ?? '',
      stock: map['stock'] ?? 0,
      hasUnlimitedStock: map['hasUnlimitedStock'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      specifications: Map<String, dynamic>.from(map['specifications'] ?? {}),
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      totalSales: map['totalSales'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isFeatured: map['isFeatured'] ?? false,
      isVerified: map['isVerified'] ?? false,
      discountPercentage: map['discountPercentage']?.toDouble(),
      originalPrice: map['originalPrice']?.toDouble(),
      discountEndDate: map['discountEndDate'] != null 
          ? DateTime.parse(map['discountEndDate']) 
          : null,
      videoUrl: map['videoUrl'],
      variants: (map['variants'] as List<dynamic>?)
          ?.map((v) => ProductVariant.fromMap(v))
          .toList() ?? [],
      shippingInfo: ShippingInfo.fromMap(map['shippingInfo'] ?? {}),
      sku: map['sku'],
      weight: (map['weight'] ?? 0.0).toDouble(),
      dimensions: ProductDimensions.fromMap(map['dimensions'] ?? {}),
      relatedProducts: List<String>.from(map['relatedProducts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'images': images,
      'category': category,
      'subcategory': subcategory,
      'type': type.toString(),
      'status': status.toString(),
      'sellerId': sellerId,
      'sellerCompanyId': sellerCompanyId,
      'sellerName': sellerName,
      'sellerCompanyName': sellerCompanyName,
      'stock': stock,
      'hasUnlimitedStock': hasUnlimitedStock,
      'tags': tags,
      'specifications': specifications,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalSales': totalSales,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFeatured': isFeatured,
      'isVerified': isVerified,
      'discountPercentage': discountPercentage,
      'originalPrice': originalPrice,
      'discountEndDate': discountEndDate?.toIso8601String(),
      'videoUrl': videoUrl,
      'variants': variants.map((v) => v.toMap()).toList(),
      'shippingInfo': shippingInfo.toMap(),
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toMap(),
      'relatedProducts': relatedProducts,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    List<String>? images,
    String? category,
    String? subcategory,
    ProductType? type,
    ProductStatus? status,
    String? sellerId,
    String? sellerCompanyId,
    String? sellerName,
    String? sellerCompanyName,
    int? stock,
    bool? hasUnlimitedStock,
    List<String>? tags,
    Map<String, dynamic>? specifications,
    double? rating,
    int? totalReviews,
    int? totalSales,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFeatured,
    bool? isVerified,
    double? discountPercentage,
    double? originalPrice,
    DateTime? discountEndDate,
    String? videoUrl,
    List<ProductVariant>? variants,
    ShippingInfo? shippingInfo,
    String? sku,
    double? weight,
    ProductDimensions? dimensions,
    List<String>? relatedProducts,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      images: images ?? this.images,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      type: type ?? this.type,
      status: status ?? this.status,
      sellerId: sellerId ?? this.sellerId,
      sellerCompanyId: sellerCompanyId ?? this.sellerCompanyId,
      sellerName: sellerName ?? this.sellerName,
      sellerCompanyName: sellerCompanyName ?? this.sellerCompanyName,
      stock: stock ?? this.stock,
      hasUnlimitedStock: hasUnlimitedStock ?? this.hasUnlimitedStock,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalSales: totalSales ?? this.totalSales,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isVerified: isVerified ?? this.isVerified,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      originalPrice: originalPrice ?? this.originalPrice,
      discountEndDate: discountEndDate ?? this.discountEndDate,
      videoUrl: videoUrl ?? this.videoUrl,
      variants: variants ?? this.variants,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      relatedProducts: relatedProducts ?? this.relatedProducts,
    );
  }

  // Getters útiles
  bool get isOnSale => discountPercentage != null && discountPercentage! > 0;
  bool get isInStock => hasUnlimitedStock || stock > 0;
  double get finalPrice => isOnSale ? price * (1 - discountPercentage! / 100) : price;
  bool get isService => type == ProductType.service;
  bool get isDigital => type == ProductType.digital;
}

enum ProductType {
  product,
  service,
  digital,
}

enum ProductStatus {
  active,
  inactive,
  outOfStock,
  discontinued,
}

extension ProductTypeExtension on ProductType {
  String get displayName {
    switch (this) {
      case ProductType.product:
        return 'Producto';
      case ProductType.service:
        return 'Servicio';
      case ProductType.digital:
        return 'Digital';
    }
  }
}

extension ProductStatusExtension on ProductStatus {
  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Activo';
      case ProductStatus.inactive:
        return 'Inactivo';
      case ProductStatus.outOfStock:
        return 'Sin Stock';
      case ProductStatus.discontinued:
        return 'Descontinuado';
    }
  }
}

class ProductVariant {
  final String id;
  final String name;
  final double priceModifier;
  final int stock;
  final String? sku;
  final Map<String, String> attributes;

  ProductVariant({
    required this.id,
    required this.name,
    this.priceModifier = 0.0,
    this.stock = 0,
    this.sku,
    this.attributes = const {},
  });

  factory ProductVariant.fromMap(Map<String, dynamic> map) {
    return ProductVariant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      priceModifier: (map['priceModifier'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
      sku: map['sku'],
      attributes: Map<String, String>.from(map['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priceModifier': priceModifier,
      'stock': stock,
      'sku': sku,
      'attributes': attributes,
    };
  }
}

class ShippingInfo {
  final bool freeShipping;
  final double shippingCost;
  final int estimatedDays;
  final List<String> availableCountries;
  final double weight;
  final bool requiresSpecialHandling;

  ShippingInfo({
    this.freeShipping = false,
    this.shippingCost = 0.0,
    this.estimatedDays = 7,
    this.availableCountries = const [],
    this.weight = 0.0,
    this.requiresSpecialHandling = false,
  });

  factory ShippingInfo.fromMap(Map<String, dynamic> map) {
    return ShippingInfo(
      freeShipping: map['freeShipping'] ?? false,
      shippingCost: (map['shippingCost'] ?? 0.0).toDouble(),
      estimatedDays: map['estimatedDays'] ?? 7,
      availableCountries: List<String>.from(map['availableCountries'] ?? []),
      weight: (map['weight'] ?? 0.0).toDouble(),
      requiresSpecialHandling: map['requiresSpecialHandling'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'freeShipping': freeShipping,
      'shippingCost': shippingCost,
      'estimatedDays': estimatedDays,
      'availableCountries': availableCountries,
      'weight': weight,
      'requiresSpecialHandling': requiresSpecialHandling,
    };
  }
}

class ProductDimensions {
  final double length;
  final double width;
  final double height;
  final String unit;

  ProductDimensions({
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
    this.unit = 'cm',
  });

  factory ProductDimensions.fromMap(Map<String, dynamic> map) {
    return ProductDimensions(
      length: (map['length'] ?? 0.0).toDouble(),
      width: (map['width'] ?? 0.0).toDouble(),
      height: (map['height'] ?? 0.0).toDouble(),
      unit: map['unit'] ?? 'cm',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'length': length,
      'width': width,
      'height': height,
      'unit': unit,
    };
  }
}

class ProductCategories {
  static const List<String> categories = [
    'Electrónicos',
    'Ropa y Accesorios',
    'Hogar y Jardín',
    'Deportes y Recreación',
    'Salud y Belleza',
    'Automóviles',
    'Libros y Medios',
    'Juguetes y Juegos',
    'Alimentos y Bebidas',
    'Servicios Profesionales',
    'Construcción',
    'Agricultura',
    'Tecnología',
    'Educación',
    'Finanzas',
    'Inmobiliario',
    'Turismo',
    'Arte y Cultura',
    'Otro',
  ];

  static Map<String, List<String>> subcategories = {
    'Electrónicos': [
      'Smartphones',
      'Computadoras',
      'Audio y Video',
      'Accesorios',
      'Gaming',
    ],
    'Ropa y Accesorios': [
      'Ropa Masculina',
      'Ropa Femenina',
      'Calzado',
      'Accesorios',
      'Joyería',
    ],
    'Servicios Profesionales': [
      'Consultoría',
      'Marketing',
      'Desarrollo Web',
      'Diseño Gráfico',
      'Contabilidad',
    ],
    // Agregar más subcategorías según necesidad
  };
}
