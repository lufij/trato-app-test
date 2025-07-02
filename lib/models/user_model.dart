class UserModel {
  final String id;
  final String email;
  final String name;
  final String? company;
  final UserType userType;
  final String? profileImage;
  final String? phone;
  final String? location;
  final String? description;
  final bool isVerified;
  final double trustScore;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.company,
    required this.userType,
    this.profileImage,
    this.phone,
    this.location,
    this.description,
    this.isVerified = false,
    this.trustScore = 0.0,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      company: map['company'],
      userType: UserType.values.firstWhere(
        (type) => type.toString() == map['userType'],
        orElse: () => UserType.vendedor,
      ),
      profileImage: map['profileImage'],
      phone: map['phone'],
      location: map['location'],
      description: map['description'],
      isVerified: map['isVerified'] ?? false,
      trustScore: (map['trustScore'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'company': company,
      'userType': userType.toString(),
      'profileImage': profileImage,
      'phone': phone,
      'location': location,
      'description': description,
      'isVerified': isVerified,
      'trustScore': trustScore,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum UserType {
  productor,
  vendedor,
  distribuidor,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.productor:
        return 'Productor';
      case UserType.vendedor:
        return 'Vendedor';
      case UserType.distribuidor:
        return 'Distribuidor';
    }
  }

  String get description {
    switch (this) {
      case UserType.productor:
        return 'Fabrico y produzco bienes';
      case UserType.vendedor:
        return 'Vendo productos al consumidor final';
      case UserType.distribuidor:
        return 'Distribuyo productos a gran escala';
    }
  }
}
