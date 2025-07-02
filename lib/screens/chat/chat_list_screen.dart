import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<ChatItem> _chats = [
    ChatItem(
      id: '1',
      name: 'María González',
      company: 'Textiles del Norte',
      lastMessage: '¿Tienes disponibilidad para 500 unidades?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      unreadCount: 2,
      isOnline: true,
      avatar: 'MG',
    ),
    ChatItem(
      id: '2',
      name: 'Carlos Rodríguez',
      company: 'Distribuidora Central',
      lastMessage: 'Perfecto, confirmamos el pedido',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
      avatar: 'CR',
    ),
    ChatItem(
      id: '3',
      name: 'Ana Martínez',
      company: 'Productos Orgánicos SA',
      lastMessage: 'Necesito cotización urgente',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      unreadCount: 1,
      isOnline: true,
      avatar: 'AM',
    ),
    ChatItem(
      id: '4',
      name: 'Luis Fernández',
      company: 'Tech Solutions',
      lastMessage: 'Gracias por la información',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 0,
      isOnline: false,
      avatar: 'LF',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats de Negocios'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda de chats
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Mostrar opciones
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros rápidos
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('Todos', true),
                const SizedBox(width: 8),
                _buildFilterChip('No leídos', false),
                const SizedBox(width: 8),
                _buildFilterChip('Activos', false),
              ],
            ),
          ),
          
          // Lista de chats
          Expanded(
            child: _chats.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      return _buildChatItem(_chats[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Iniciar nuevo chat
        },
        backgroundColor: AppTheme.accentOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implementar filtrado
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
    );
  }

  Widget _buildChatItem(ChatItem chat) {
    return InkWell(
      onTap: () {
        // TODO: Navegar al chat individual
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar con indicador de estado
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.primaryBlue,
                  child: Text(
                    chat.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Información del chat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatTimestamp(chat.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.elegantGray,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    chat.company,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: chat.unreadCount > 0 
                                ? AppTheme.darkGray 
                                : AppTheme.elegantGray,
                            fontWeight: chat.unreadCount > 0 
                                ? FontWeight.w500 
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
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
            Icons.chat_bubble_outline,
            size: 80,
            color: AppTheme.elegantGray.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes chats aún',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.elegantGray,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Conecta con otros usuarios para\nempezar a hacer negocios',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.elegantGray,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Navegar a descubrir usuarios
            },
            icon: const Icon(Icons.people),
            label: const Text('Descubrir Usuarios'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

class ChatItem {
  final String id;
  final String name;
  final String company;
  final String lastMessage;
  final DateTime timestamp;
  final int unreadCount;
  final bool isOnline;
  final String avatar;

  ChatItem({
    required this.id,
    required this.name,
    required this.company,
    required this.lastMessage,
    required this.timestamp,
    required this.unreadCount,
    required this.isOnline,
    required this.avatar,
  });
}
