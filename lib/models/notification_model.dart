import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? userId;
  final String? relatedId; // ID del chat, producto, etc.
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.userId,
    this.relatedId,
    this.data,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (type) => type.toString() == map['type'],
        orElse: () => NotificationType.general,
      ),
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] ?? false,
      userId: map['userId'],
      relatedId: map['relatedId'],
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'userId': userId,
      'relatedId': relatedId,
      'data': data,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? userId,
    String? relatedId,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      relatedId: relatedId ?? this.relatedId,
      data: data ?? this.data,
    );
  }
}

enum NotificationType {
  message,
  businessOpportunity,
  connectionRequest,
  productInterest,
  reminder,
  verification,
  general,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.message:
        return 'Nuevo Mensaje';
      case NotificationType.businessOpportunity:
        return 'Oportunidad de Negocio';
      case NotificationType.connectionRequest:
        return 'Solicitud de Conexión';
      case NotificationType.productInterest:
        return 'Interés en Producto';
      case NotificationType.reminder:
        return 'Recordatorio';
      case NotificationType.verification:
        return 'Verificación';
      case NotificationType.general:
        return 'Notificación';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.message:
        return Icons.message;
      case NotificationType.businessOpportunity:
        return Icons.business_center;
      case NotificationType.connectionRequest:
        return Icons.person_add;
      case NotificationType.productInterest:
        return Icons.favorite;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.verification:
        return Icons.verified;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.message:
        return const Color(0xFF1565C0); // primaryBlue
      case NotificationType.businessOpportunity:
        return const Color(0xFF2E7D32); // trustGreen
      case NotificationType.connectionRequest:
        return const Color(0xFFFF6F00); // accentOrange
      case NotificationType.productInterest:
        return const Color(0xFFE91E63); // pink
      case NotificationType.reminder:
        return const Color(0xFFFF9800); // warningAmber
      case NotificationType.verification:
        return const Color(0xFF4CAF50); // successGreen
      case NotificationType.general:
        return const Color(0xFF424242); // elegantGray
    }
  }
}
