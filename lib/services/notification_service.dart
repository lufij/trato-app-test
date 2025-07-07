import 'dart:async';
import 'dart:math';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();
  
  final StreamController<NotificationModel> _newNotificationController =
      StreamController<NotificationModel>.broadcast();

  final List<NotificationModel> _notifications = [];
  Timer? _reminderTimer;

  // Streams
  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;
  
  Stream<NotificationModel> get newNotificationStream =>
      _newNotificationController.stream;

  // Getters
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  
  List<NotificationModel> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  // Inicializar el servicio
  void initialize() {
    _loadInitialNotifications();
    _startReminderTimer();
  }

  // Cargar notificaciones iniciales (simuladas)
  void _loadInitialNotifications() {
    final initialNotifications = [
      NotificationModel(
        id: '1',
        title: 'Nuevo mensaje de María González',
        message: '¿Tienes disponibilidad para 500 unidades?',
        type: NotificationType.message,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        relatedId: 'chat_1',
      ),
      NotificationModel(
        id: '2',
        title: 'Nueva oportunidad de negocio',
        message: 'Distribuidor busca productos textiles en tu área',
        type: NotificationType.businessOpportunity,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        relatedId: 'opportunity_1',
      ),
      NotificationModel(
        id: '3',
        title: 'Solicitud de conexión',
        message: 'Carlos Rodríguez quiere conectar contigo',
        type: NotificationType.connectionRequest,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        relatedId: 'user_carlos',
      ),
    ];

    _notifications.addAll(initialNotifications);
    _notificationsController.add(_notifications);
  }

  // Agregar nueva notificación
  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    _notificationsController.add(_notifications);
    _newNotificationController.add(notification);
  }

  // Crear notificación rápida
  void createNotification({
    required String title,
    required String message,
    required NotificationType type,
    String? relatedId,
    Map<String, dynamic>? data,
  }) {
    final notification = NotificationModel(
      id: _generateId(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      relatedId: relatedId,
      data: data,
    );
    
    addNotification(notification);
  }

  // Marcar como leída
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _notificationsController.add(_notifications);
    }
  }

  // Marcar todas como leídas
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    _notificationsController.add(_notifications);
  }

  // Eliminar notificación
  void removeNotification(String notificationId) {
    _notifications.removeWhere((n) => n.id == notificationId);
    _notificationsController.add(_notifications);
  }

  // Limpiar todas las notificaciones
  void clearAll() {
    _notifications.clear();
    _notificationsController.add(_notifications);
  }

  // Obtener notificaciones por tipo
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Simular notificaciones de mensajes
  void simulateMessageNotification(String senderName, String message) {
    createNotification(
      title: 'Nuevo mensaje de $senderName',
      message: message,
      type: NotificationType.message,
      relatedId: 'chat_${senderName.toLowerCase().replaceAll(' ', '_')}',
    );
  }

  // Simular notificaciones de oportunidades de negocio
  void simulateBusinessOpportunity(String opportunity) {
    createNotification(
      title: 'Nueva oportunidad de negocio',
      message: opportunity,
      type: NotificationType.businessOpportunity,
    );
  }

  // Simular solicitudes de conexión
  void simulateConnectionRequest(String userName) {
    createNotification(
      title: 'Nueva solicitud de conexión',
      message: '$userName quiere conectar contigo',
      type: NotificationType.connectionRequest,
      relatedId: 'user_${userName.toLowerCase().replaceAll(' ', '_')}',
    );
  }

  // Timer para recordatorios automáticos
  void _startReminderTimer() {
    _reminderTimer = Timer.periodic(const Duration(minutes: 30), (timer) {
      if (unreadCount > 0) {
        createNotification(
          title: 'Recordatorio',
          message: 'Tienes $unreadCount notificaciones sin leer',
          type: NotificationType.reminder,
        );
      }
    });
  }

  // Generar ID único
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  // Limpiar recursos
  void dispose() {
    _reminderTimer?.cancel();
    _notificationsController.close();
    _newNotificationController.close();
  }

  // Métodos para simular actividad (para demostración)
  void simulateActivity() {
    Timer.periodic(const Duration(seconds: 45), (timer) {
      final random = Random();
      final activities = [
        () => simulateMessageNotification(
            'Ana Martínez', 'Necesito cotización para 200 unidades'),
        () => simulateBusinessOpportunity(
            'Empresa busca proveedor de materiales de construcción'),
        () => simulateConnectionRequest('Luis Fernández'),
        () => createNotification(
            title: 'Producto favorito disponible',
            message: 'El producto que guardaste está en oferta',
            type: NotificationType.productInterest),
        () => createNotification(
            title: 'Verificación completada',
            message: 'Tu empresa ha sido verificada exitosamente',
            type: NotificationType.verification),
      ];

      if (random.nextBool()) {
        activities[random.nextInt(activities.length)]();
      }
    });
  }

  // Notificar interés de trato (handshake)
  void notifyHandshake({
    required String toUserId,
    required String fromUserName,
    required String postTitle,
    required String postId,
  }) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '¡Quieren hacer trato contigo!',
      message: '$fromUserName está interesado en tu publicación: "$postTitle"',
      type: NotificationType.productInterest,
      timestamp: DateTime.now(),
      userId: toUserId,
      relatedId: postId,
      data: {
        'fromUserName': fromUserName,
        'postTitle': postTitle,
        'postId': postId,
      },
    );
    addNotification(notification);
  }
}
