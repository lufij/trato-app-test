import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  String _selectedFilter = 'Todas';
  
  final List<String> _filters = [
    'Todas',
    'No leídas',
    'Mensajes',
    'Oportunidades',
    'Conexiones',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              _notificationService.markAllAsRead();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las notificaciones marcadas como leídas'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            tooltip: 'Marcar todas como leídas',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_all') {
                _showClearAllDialog();
              } else if (value == 'settings') {
                _showNotificationSettings();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Configuración'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Limpiar todas', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: StreamBuilder<List<NotificationModel>>(
              stream: _notificationService.notificationsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notifications = _getFilteredNotifications(snapshot.data ?? []);

                if (notifications.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationCard(notifications[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showTestNotificationDialog();
        },
        backgroundColor: AppTheme.accentOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert),
        label: const Text('Simular'),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryBlue,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.elegantGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notification.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: notification.isRead 
            ? BorderSide.none 
            : BorderSide(color: notification.type.color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono de tipo de notificación
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notification.type.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  notification.type.icon,
                  color: notification.type.color,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Contenido de la notificación
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead 
                                  ? FontWeight.w500 
                                  : FontWeight.w600,
                              color: notification.isRead 
                                  ? AppTheme.elegantGray 
                                  : AppTheme.darkGray,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: notification.type.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: notification.isRead 
                            ? AppTheme.elegantGray 
                            : AppTheme.darkGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: notification.type.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            notification.type.displayName,
                            style: TextStyle(
                              color: notification.type.color,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.elegantGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Botón de opciones
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'mark_read') {
                    _notificationService.markAsRead(notification.id);
                  } else if (value == 'delete') {
                    _notificationService.removeNotification(notification.id);
                  }
                },
                itemBuilder: (context) => [
                  if (!notification.isRead)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.done),
                          SizedBox(width: 8),
                          Text('Marcar como leída'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: AppTheme.elegantGray,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppTheme.elegantGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _getEmptyStateTitle(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.elegantGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getEmptyStateSubtitle(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.elegantGray,
            ),
          ),
        ],
      ),
    );
  }

  List<NotificationModel> _getFilteredNotifications(List<NotificationModel> notifications) {
    switch (_selectedFilter) {
      case 'No leídas':
        return notifications.where((n) => !n.isRead).toList();
      case 'Mensajes':
        return notifications.where((n) => n.type == NotificationType.message).toList();
      case 'Oportunidades':
        return notifications.where((n) => n.type == NotificationType.businessOpportunity).toList();
      case 'Conexiones':
        return notifications.where((n) => n.type == NotificationType.connectionRequest).toList();
      default:
        return notifications;
    }
  }

  String _getEmptyStateTitle() {
    switch (_selectedFilter) {
      case 'No leídas':
        return 'No tienes notificaciones sin leer';
      case 'Mensajes':
        return 'No tienes notificaciones de mensajes';
      case 'Oportunidades':
        return 'No tienes oportunidades de negocio';
      case 'Conexiones':
        return 'No tienes solicitudes de conexión';
      default:
        return 'No tienes notificaciones';
    }
  }

  String _getEmptyStateSubtitle() {
    switch (_selectedFilter) {
      case 'No leídas':
        return 'Todas tus notificaciones están al día';
      case 'Mensajes':
        return 'Los nuevos mensajes aparecerán aquí';
      case 'Oportunidades':
        return 'Las oportunidades de negocio aparecerán aquí';
      case 'Conexiones':
        return 'Las solicitudes de conexión aparecerán aquí';
      default:
        return 'Las notificaciones aparecerán aquí cuando\ntengas actividad en TRATO';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Marcar como leída
    if (!notification.isRead) {
      _notificationService.markAsRead(notification.id);
    }

    // Navegar según el tipo de notificación
    switch (notification.type) {
      case NotificationType.message:
        // TODO: Navegar al chat específico
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navegando al chat...')),
        );
        break;
      case NotificationType.connectionRequest:
        // TODO: Navegar a solicitudes de conexión
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navegando a solicitudes...')),
        );
        break;
      case NotificationType.businessOpportunity:
        // TODO: Navegar a oportunidades
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navegando a oportunidades...')),
        );
        break;
      default:
        break;
    }
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar notificaciones'),
        content: const Text('¿Estás seguro de que quieres eliminar todas las notificaciones?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _notificationService.clearAll();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todas las notificaciones eliminadas'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración de Notificaciones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingTile('Mensajes', true),
            _buildSettingTile('Oportunidades de Negocio', true),
            _buildSettingTile('Solicitudes de Conexión', true),
            _buildSettingTile('Recordatorios', false),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // TODO: Implementar configuración de notificaciones
      },
      activeColor: AppTheme.primaryBlue,
    );
  }

  void _showTestNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Simular Notificación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.message, color: AppTheme.primaryBlue),
              title: const Text('Nuevo Mensaje'),
              onTap: () {
                _notificationService.simulateMessageNotification(
                  'Pedro García', 
                  '¿Podemos agendar una reunión?'
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.business_center, color: AppTheme.trustGreen),
              title: const Text('Oportunidad de Negocio'),
              onTap: () {
                _notificationService.simulateBusinessOpportunity(
                  'Empresa busca proveedor de tecnología'
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: AppTheme.accentOrange),
              title: const Text('Solicitud de Conexión'),
              onTap: () {
                _notificationService.simulateConnectionRequest('Sofia López');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
