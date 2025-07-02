import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/user_model.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Red'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda de usuarios
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // TODO: Invitar contactos
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Conexiones'),
            Tab(text: 'Solicitudes'),
            Tab(text: 'Descubrir'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConnectionsTab(),
          _buildRequestsTab(),
          _buildDiscoverTab(),
        ],
      ),
    );
  }

  Widget _buildConnectionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildConnectionCard(index, isConnected: true);
      },
    );
  }

  Widget _buildRequestsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildRequestCard(index);
      },
    );
  }

  Widget _buildDiscoverTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildConnectionCard(index, isConnected: false);
      },
    );
  }

  Widget _buildConnectionCard(int index, {required bool isConnected}) {
    final userTypes = UserType.values;
    final userType = userTypes[index % userTypes.length];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryBlue,
                  child: Text(
                    'U${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (index % 4 == 0) // Usuario verificado
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified,
                        color: AppTheme.trustGreen,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(width: 16),
            
            // Información del usuario
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuario ${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getUserTypeColor(userType).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userType.displayName,
                      style: TextStyle(
                        color: _getUserTypeColor(userType),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Empresa ${index + 1} S.A.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.${5 + index % 5}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.handshake,
                        size: 14,
                        color: AppTheme.elegantGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(index + 1) * 12} tratos',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Botones de acción
            Column(
              children: [
                if (isConnected) ...[
                  IconButton(
                    onPressed: () {
                      // TODO: Enviar mensaje
                    },
                    icon: const Icon(Icons.message),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                      foregroundColor: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: () {
                      // TODO: Ver perfil
                    },
                    icon: const Icon(Icons.person),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.elegantGray.withOpacity(0.1),
                      foregroundColor: AppTheme.elegantGray,
                    ),
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Enviar solicitud de conexión
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Conectar'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(int index) {
    final userTypes = UserType.values;
    final userType = userTypes[index % userTypes.length];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                'S${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solicitud ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userType.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getUserTypeColor(userType),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quiere conectar contigo',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
            // Botones de acción
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Rechazar solicitud
                  },
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.errorRed.withOpacity(0.1),
                    foregroundColor: AppTheme.errorRed,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // TODO: Aceptar solicitud
                  },
                  icon: const Icon(Icons.check),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.trustGreen.withOpacity(0.1),
                    foregroundColor: AppTheme.trustGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserTypeColor(UserType userType) {
    switch (userType) {
      case UserType.productor:
        return AppTheme.trustGreen;
      case UserType.vendedor:
        return AppTheme.primaryBlue;
      case UserType.distribuidor:
        return AppTheme.accentOrange;
    }
  }
}
