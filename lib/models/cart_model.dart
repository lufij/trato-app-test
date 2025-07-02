class CartModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? couponCode;
  final double couponDiscount;
  final double shippingCost;
  final String currency;

  CartModel({
    required this.id,
    required this.userId,
    this.items = const [],
    required this.createdAt,
    required this.updatedAt,
    this.couponCode,
    this.couponDiscount = 0.0,
    this.shippingCost = 0.0,
    this.currency = 'USD',
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromMap(item))
          .toList() ?? [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      couponCode: map['couponCode'],
      couponDiscount: (map['couponDiscount'] ?? 0.0).toDouble(),
      shippingCost: (map['shippingCost'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'couponCode': couponCode,
      'couponDiscount': couponDiscount,
      'shippingCost': shippingCost,
      'currency': currency,
    };
  }

  CartModel copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? couponCode,
    double? couponDiscount,
    double? shippingCost,
    String? currency,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      couponCode: couponCode ?? this.couponCode,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      shippingCost: shippingCost ?? this.shippingCost,
      currency: currency ?? this.currency,
    );
  }

  // Getters útiles
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalDiscount => couponDiscount;
  double get total => subtotal - totalDiscount + shippingCost;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  // Métodos útiles
  CartItem? findItem(String productId, String? variantId) {
    try {
      return items.firstWhere(
        (item) => item.productId == productId && item.variantId == variantId,
      );
    } catch (e) {
      return null;
    }
  }

  bool hasItem(String productId, String? variantId) {
    return findItem(productId, variantId) != null;
  }

  List<String> get sellerIds {
    return items.map((item) => item.sellerId).toSet().toList();
  }

  Map<String, List<CartItem>> get itemsBySeller {
    final Map<String, List<CartItem>> result = {};
    for (final item in items) {
      if (!result.containsKey(item.sellerId)) {
        result[item.sellerId] = [];
      }
      result[item.sellerId]!.add(item);
    }
    return result;
  }
}

class CartItem {
  final String productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final String sellerId;
  final String sellerName;
  final String sellerCompanyId;
  final String sellerCompanyName;
  final DateTime addedAt;
  final Map<String, dynamic> productData;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    this.variantId,
    this.variantName,
    required this.sellerId,
    required this.sellerName,
    required this.sellerCompanyId,
    required this.sellerCompanyName,
    required this.addedAt,
    this.productData = const {},
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      variantId: map['variantId'],
      variantName: map['variantName'],
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerCompanyId: map['sellerCompanyId'] ?? '',
      sellerCompanyName: map['sellerCompanyName'] ?? '',
      addedAt: DateTime.parse(map['addedAt']),
      productData: Map<String, dynamic>.from(map['productData'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'variantId': variantId,
      'variantName': variantName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerCompanyId': sellerCompanyId,
      'sellerCompanyName': sellerCompanyName,
      'addedAt': addedAt.toIso8601String(),
      'productData': productData,
    };
  }

  CartItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? unitPrice,
    int? quantity,
    String? variantId,
    String? variantName,
    String? sellerId,
    String? sellerName,
    String? sellerCompanyId,
    String? sellerCompanyName,
    DateTime? addedAt,
    Map<String, dynamic>? productData,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerCompanyId: sellerCompanyId ?? this.sellerCompanyId,
      sellerCompanyName: sellerCompanyName ?? this.sellerCompanyName,
      addedAt: addedAt ?? this.addedAt,
      productData: productData ?? this.productData,
    );
  }

  // Getters útiles
  double get totalPrice => unitPrice * quantity;
  String get displayName => variantName != null ? '$productName - $variantName' : productName;
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerEmail;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double totalDiscount;
  final double total;
  final String currency;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final ShippingStatus shippingStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ShippingAddress shippingAddress;
  final PaymentInfo paymentInfo;
  final String? notes;
  final String? trackingNumber;
  final DateTime? estimatedDelivery;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerEmail,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.totalDiscount,
    required this.total,
    this.currency = 'USD',
    required this.status,
    required this.paymentStatus,
    required this.shippingStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.shippingAddress,
    required this.paymentInfo,
    this.notes,
    this.trackingNumber,
    this.estimatedDelivery,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      buyerEmail: map['buyerEmail'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      shippingCost: (map['shippingCost'] ?? 0.0).toDouble(),
      totalDiscount: (map['totalDiscount'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
      status: OrderStatus.values.firstWhere(
        (status) => status.toString() == map['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (status) => status.toString() == map['paymentStatus'],
        orElse: () => PaymentStatus.pending,
      ),
      shippingStatus: ShippingStatus.values.firstWhere(
        (status) => status.toString() == map['shippingStatus'],
        orElse: () => ShippingStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      shippingAddress: ShippingAddress.fromMap(map['shippingAddress'] ?? {}),
      paymentInfo: PaymentInfo.fromMap(map['paymentInfo'] ?? {}),
      notes: map['notes'],
      trackingNumber: map['trackingNumber'],
      estimatedDelivery: map['estimatedDelivery'] != null 
          ? DateTime.parse(map['estimatedDelivery']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'totalDiscount': totalDiscount,
      'total': total,
      'currency': currency,
      'status': status.toString(),
      'paymentStatus': paymentStatus.toString(),
      'shippingStatus': shippingStatus.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'shippingAddress': shippingAddress.toMap(),
      'paymentInfo': paymentInfo.toMap(),
      'notes': notes,
      'trackingNumber': trackingNumber,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? buyerId,
    String? buyerName,
    String? buyerEmail,
    List<OrderItem>? items,
    double? subtotal,
    double? shippingCost,
    double? totalDiscount,
    double? total,
    String? currency,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    ShippingStatus? shippingStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShippingAddress? shippingAddress,
    PaymentInfo? paymentInfo,
    String? notes,
    String? trackingNumber,
    DateTime? estimatedDelivery,
  }) {
    return OrderModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerEmail: buyerEmail ?? this.buyerEmail,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      totalDiscount: totalDiscount ?? this.totalDiscount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shippingStatus: shippingStatus ?? this.shippingStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentInfo: paymentInfo ?? this.paymentInfo,
      notes: notes ?? this.notes,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double unitPrice;
  final int quantity;
  final String? variantId;
  final String? variantName;
  final String sellerId;
  final String sellerName;
  final String sellerCompanyId;
  final String sellerCompanyName;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.unitPrice,
    required this.quantity,
    this.variantId,
    this.variantName,
    required this.sellerId,
    required this.sellerName,
    required this.sellerCompanyId,
    required this.sellerCompanyName,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      variantId: map['variantId'],
      variantName: map['variantName'],
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerCompanyId: map['sellerCompanyId'] ?? '',
      sellerCompanyName: map['sellerCompanyName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'variantId': variantId,
      'variantName': variantName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerCompanyId': sellerCompanyId,
      'sellerCompanyName': sellerCompanyName,
    };
  }

  double get totalPrice => unitPrice * quantity;
}

class ShippingAddress {
  final String fullName;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;

  ShippingAddress({
    required this.fullName,
    required this.address1,
    this.address2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phone,
  });

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      fullName: map['fullName'] ?? '',
      address1: map['address1'] ?? '',
      address2: map['address2'],
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'phone': phone,
    };
  }
}

class PaymentInfo {
  final String method;
  final String? transactionId;
  final String? paymentIntentId;
  final Map<String, dynamic> metadata;

  PaymentInfo({
    required this.method,
    this.transactionId,
    this.paymentIntentId,
    this.metadata = const {},
  });

  factory PaymentInfo.fromMap(Map<String, dynamic> map) {
    return PaymentInfo(
      method: map['method'] ?? '',
      transactionId: map['transactionId'],
      paymentIntentId: map['paymentIntentId'],
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'transactionId': transactionId,
      'paymentIntentId': paymentIntentId,
      'metadata': metadata,
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  partiallyRefunded,
}

enum ShippingStatus {
  pending,
  processing,
  shipped,
  inTransit,
  delivered,
  returned,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.confirmed:
        return 'Confirmado';
      case OrderStatus.processing:
        return 'Procesando';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
      case OrderStatus.refunded:
        return 'Reembolsado';
    }
  }
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.paid:
        return 'Pagado';
      case PaymentStatus.failed:
        return 'Fallido';
      case PaymentStatus.refunded:
        return 'Reembolsado';
      case PaymentStatus.partiallyRefunded:
        return 'Parcialmente Reembolsado';
    }
  }
}

extension ShippingStatusExtension on ShippingStatus {
  String get displayName {
    switch (this) {
      case ShippingStatus.pending:
        return 'Pendiente';
      case ShippingStatus.processing:
        return 'Procesando';
      case ShippingStatus.shipped:
        return 'Enviado';
      case ShippingStatus.inTransit:
        return 'En Tránsito';
      case ShippingStatus.delivered:
        return 'Entregado';
      case ShippingStatus.returned:
        return 'Devuelto';
    }
  }
}
