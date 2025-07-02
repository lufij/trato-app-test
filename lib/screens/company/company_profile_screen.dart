import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/company_model.dart';
import '../../services/company_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/trato_logo.dart';
import 'company_setup_screen.dart';

class CompanyProfileScreen extends StatefulWidget {
  final String? companyId;
  final bool isOwnProfile;
  
  const CompanyProfileScreen({
    super.key,
    this.companyId,
    this.isOwnProfile = true,
  });

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen>
    with SingleTickerProviderStateMixin {
  final _companyService = CompanyService();
  CompanyModel? _company;
  bool _isLoading = true;
  bool _isFollowing = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    try {
      CompanyModel? company;
      
      if (widget.companyId != null) {
        company = await _companyService.getCompanyById(widget.companyId!);
      } else if (widget.isOwnProfile) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          company = await _companyService.getCompanyByOwnerId(user.uid);
        }
      }
      
      setState(() {
        _company = company;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar empresa: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil de Empresa'),
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_company == null) {
      return _buildNoCompanyScreen();
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              actions: widget.isOwnProfile
                  ? [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editCompany,
                      ),
                    ]
                  : [
                      IconButton(
                        icon: Icon(_isFollowing ? Icons.favorite : Icons.favorite_border),
                        onPressed: _toggleFollow,
                      ),
                    ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildCompanyHeader(),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildInfoTab(),
                  _buildGalleryTab(),
                  _buildStatsTab(),
                  _buildContactTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoCompanyScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Empresa'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TratoLogo(size: 120),
              const SizedBox(height: 32),
              const Text(
                '¡Configura tu empresa!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Crea el perfil de tu empresa para comenzar a hacer negocios en TRATO',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _createCompany,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Configurar Empresa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Logo de la empresa
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _company!.logo != null
                    ? ClipOval(
                        child: Image.network(
                          _company!.logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultLogo();
                          },
                        ),
                      )
                    : _buildDefaultLogo(),
              ),
              
              const SizedBox(height: 16),
              
              // Nombre de la empresa
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _company!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_company!.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified,
                      color: AppTheme.trustGreen,
                      size: 24,
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Sector y tamaño
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_company!.sector} • ${_company!.size.displayName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Ubicación
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _company!.location,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.primaryBlue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _company!.name.isNotEmpty ? _company!.name[0].toUpperCase() : 'E',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryBlue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppTheme.primaryBlue,
        tabs: const [
          Tab(text: 'Info', icon: Icon(Icons.info_outline)),
          Tab(text: 'Galería', icon: Icon(Icons.photo_library)),
          Tab(text: 'Stats', icon: Icon(Icons.analytics)),
          Tab(text: 'Contacto', icon: Icon(Icons.contact_phone)),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estadísticas rápidas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  title: 'Seguidores',
                  value: _company!.followers.toString(),
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star,
                  title: 'Calificación',
                  value: _company!.rating.toStringAsFixed(1),
                  color: AppTheme.accentOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.inventory,
                  title: 'Productos',
                  value: _company!.totalProducts.toString(),
                  color: AppTheme.trustGreen,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Descripción
          _buildInfoSection(
            title: 'Acerca de la Empresa',
            content: _company!.description,
            icon: Icons.description,
          ),
          
          const SizedBox(height: 24),
          
          // Información adicional
          _buildInfoSection(
            title: 'Fundada en',
            content: '${_company!.foundedDate.year}',
            icon: Icons.calendar_today,
          ),
          
          if (_company!.certifications.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildCertificationsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    if (_company!.gallery.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No hay imágenes en la galería',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _company!.gallery.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _company!.gallery[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStatCard(
            icon: Icons.people,
            title: 'Total Seguidores',
            value: _company!.followers.toString(),
            color: AppTheme.primaryBlue,
            isLarge: true,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            icon: Icons.star,
            title: 'Calificación Promedio',
            value: '${_company!.rating.toStringAsFixed(1)} (${_company!.totalReviews} reseñas)',
            color: AppTheme.accentOrange,
            isLarge: true,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            icon: Icons.inventory,
            title: 'Productos Totales',
            value: _company!.totalProducts.toString(),
            color: AppTheme.trustGreen,
            isLarge: true,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            icon: Icons.handshake,
            title: 'Ventas Realizadas',
            value: _company!.totalSales.toString(),
            color: AppTheme.primaryBlue,
            isLarge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (_company!.phone != null)
            _buildContactItem(
              icon: Icons.phone,
              title: 'Teléfono',
              value: _company!.phone!,
              onTap: () {
                // TODO: Implementar llamada
              },
            ),
          
          if (_company!.email != null)
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              value: _company!.email!,
              onTap: () {
                // TODO: Implementar email
              },
            ),
          
          if (_company!.website != null)
            _buildContactItem(
              icon: Icons.language,
              title: 'Sitio Web',
              value: _company!.website!,
              onTap: () {
                // TODO: Implementar abrir web
              },
            ),
          
          if (_company!.address != null)
            _buildContactItem(
              icon: Icons.location_on,
              title: 'Dirección',
              value: _company!.address!,
              onTap: () {
                // TODO: Implementar mapa
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isLarge = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isLarge ? 24 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: isLarge ? 40 : 32,
          ),
          SizedBox(height: isLarge ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: isLarge ? 24 : 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isLarge ? 8 : 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: isLarge ? 14 : 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryBlue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCertificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.verified, color: AppTheme.primaryBlue),
            SizedBox(width: 8),
            Text(
              'Certificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _company!.certifications.map((cert) {
            return Chip(
              label: Text(cert),
              backgroundColor: AppTheme.trustGreen.withOpacity(0.1),
              labelStyle: const TextStyle(color: AppTheme.trustGreen),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryBlue),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Future<void> _createCompany() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CompanySetupScreen(),
      ),
    );
    
    if (result == true) {
      _loadCompany();
    }
  }

  Future<void> _editCompany() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CompanySetupScreen(existingCompany: _company),
      ),
    );
    
    if (result == true) {
      _loadCompany();
    }
  }

  Future<void> _toggleFollow() async {
    // TODO: Implementar seguir/dejar de seguir
    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
