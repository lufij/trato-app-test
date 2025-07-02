import 'package:flutter/material.dart';
import '../models/company_model.dart';
import '../theme/app_theme.dart';
import '../screens/company/company_profile_screen.dart';

class CompanyCard extends StatelessWidget {
  final CompanyModel company;
  final bool showFollowButton;
  final VoidCallback? onFollow;
  final VoidCallback? onUnfollow;
  final bool isFollowing;

  const CompanyCard({
    super.key,
    required this.company,
    this.showFollowButton = true,
    this.onFollow,
    this.onUnfollow,
    this.isFollowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CompanyProfileScreen(
                companyId: company.id,
                isOwnProfile: false,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con logo y nombre
              Row(
                children: [
                  // Logo de la empresa
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: company.logo != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              company.logo!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultLogo();
                              },
                            ),
                          )
                        : _buildDefaultLogo(),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Información de la empresa
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                company.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryBlue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (company.isVerified) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.verified,
                                color: AppTheme.trustGreen,
                                size: 20,
                              ),
                            ],
                          ],
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            company.sector,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                company.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Botón de seguir
                  if (showFollowButton)
                    _buildFollowButton(),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Descripción
              Text(
                company.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Estadísticas
              Row(
                children: [
                  _buildStatChip(
                    icon: Icons.people,
                    value: company.followers.toString(),
                    label: 'Seguidores',
                    color: AppTheme.primaryBlue,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  _buildStatChip(
                    icon: Icons.star,
                    value: company.rating.toStringAsFixed(1),
                    label: 'Rating',
                    color: AppTheme.accentOrange,
                  ),
                  
                  const SizedBox(width: 12),
                  
                  _buildStatChip(
                    icon: Icons.inventory,
                    value: company.totalProducts.toString(),
                    label: 'Productos',
                    color: AppTheme.trustGreen,
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
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          company.name.isNotEmpty ? company.name[0].toUpperCase() : 'E',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFollowButton() {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: isFollowing ? onUnfollow : onFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.grey : AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          isFollowing ? 'Siguiendo' : 'Seguir',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyListTile extends StatelessWidget {
  final CompanyModel company;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CompanyListTile({
    super.key,
    required this.company,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: company.logo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  company.logo!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultLogo();
                  },
                ),
              )
            : _buildDefaultLogo(),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              company.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (company.isVerified) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.verified,
              color: AppTheme.trustGreen,
              size: 16,
            ),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            company.sector,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 12,
                color: Colors.grey,
              ),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  company.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDefaultLogo() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          company.name.isNotEmpty ? company.name[0].toUpperCase() : 'E',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
