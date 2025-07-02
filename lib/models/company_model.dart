class CompanyModel {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final String sector;
  final String location;
  final String? website;
  final String? phone;
  final String? email;
  final List<String> socialMedia;
  final bool isVerified;
  final double rating;
  final int totalReviews;
  final int followers;
  final int following;
  final int totalProducts;
  final int totalSales;
  final DateTime foundedDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ownerId;
  final CompanySize size;
  final List<String> certifications;
  final List<String> gallery;
  final Map<String, dynamic> businessHours;
  final String? address;
  final double? latitude;
  final double? longitude;

  CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    required this.sector,
    required this.location,
    this.website,
    this.phone,
    this.email,
    this.socialMedia = const [],
    this.isVerified = false,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.followers = 0,
    this.following = 0,
    this.totalProducts = 0,
    this.totalSales = 0,
    required this.foundedDate,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
    required this.size,
    this.certifications = const [],
    this.gallery = const [],
    this.businessHours = const {},
    this.address,
    this.latitude,
    this.longitude,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      logo: map['logo'],
      sector: map['sector'] ?? '',
      location: map['location'] ?? '',
      website: map['website'],
      phone: map['phone'],
      email: map['email'],
      socialMedia: List<String>.from(map['socialMedia'] ?? []),
      isVerified: map['isVerified'] ?? false,
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      followers: map['followers'] ?? 0,
      following: map['following'] ?? 0,
      totalProducts: map['totalProducts'] ?? 0,
      totalSales: map['totalSales'] ?? 0,
      foundedDate: DateTime.parse(map['foundedDate']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      ownerId: map['ownerId'] ?? '',
      size: CompanySize.values.firstWhere(
        (size) => size.toString() == map['size'],
        orElse: () => CompanySize.pequena,
      ),
      certifications: List<String>.from(map['certifications'] ?? []),
      gallery: List<String>.from(map['gallery'] ?? []),
      businessHours: Map<String, dynamic>.from(map['businessHours'] ?? {}),
      address: map['address'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'sector': sector,
      'location': location,
      'website': website,
      'phone': phone,
      'email': email,
      'socialMedia': socialMedia,
      'isVerified': isVerified,
      'rating': rating,
      'totalReviews': totalReviews,
      'followers': followers,
      'following': following,
      'totalProducts': totalProducts,
      'totalSales': totalSales,
      'foundedDate': foundedDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'ownerId': ownerId,
      'size': size.toString(),
      'certifications': certifications,
      'gallery': gallery,
      'businessHours': businessHours,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  CompanyModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logo,
    String? sector,
    String? location,
    String? website,
    String? phone,
    String? email,
    List<String>? socialMedia,
    bool? isVerified,
    double? rating,
    int? totalReviews,
    int? followers,
    int? following,
    int? totalProducts,
    int? totalSales,
    DateTime? foundedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
    CompanySize? size,
    List<String>? certifications,
    List<String>? gallery,
    Map<String, dynamic>? businessHours,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      sector: sector ?? this.sector,
      location: location ?? this.location,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      socialMedia: socialMedia ?? this.socialMedia,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      totalProducts: totalProducts ?? this.totalProducts,
      totalSales: totalSales ?? this.totalSales,
      foundedDate: foundedDate ?? this.foundedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
      size: size ?? this.size,
      certifications: certifications ?? this.certifications,
      gallery: gallery ?? this.gallery,
      businessHours: businessHours ?? this.businessHours,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

enum CompanySize {
  micro,
  pequena,
  mediana,
  grande,
}

extension CompanySizeExtension on CompanySize {
  String get displayName {
    switch (this) {
      case CompanySize.micro:
        return 'Microempresa';
      case CompanySize.pequena:
        return 'Pequeña Empresa';
      case CompanySize.mediana:
        return 'Mediana Empresa';
      case CompanySize.grande:
        return 'Gran Empresa';
    }
  }

  String get description {
    switch (this) {
      case CompanySize.micro:
        return '1-10 empleados';
      case CompanySize.pequena:
        return '11-50 empleados';
      case CompanySize.mediana:
        return '51-250 empleados';
      case CompanySize.grande:
        return '250+ empleados';
    }
  }
}

class BusinessSector {
  static const List<String> sectors = [
    'Agricultura y Ganadería',
    'Alimentación y Bebidas',
    'Automotriz',
    'Construcción',
    'Educación',
    'Energía',
    'Entretenimiento',
    'Farmacéutico',
    'Finanzas',
    'Inmobiliario',
    'Manufactura',
    'Retail',
    'Salud',
    'Servicios',
    'Tecnología',
    'Textil',
    'Transporte',
    'Turismo',
    'Otro',
  ];
}
