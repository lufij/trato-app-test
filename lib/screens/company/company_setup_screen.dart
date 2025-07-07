import 'package:flutter/material.dart';
import '../../models/company_model.dart';
import '../../services/company_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/trato_logo.dart';

class CompanySetupScreen extends StatefulWidget {
  final CompanyModel? existingCompany;
  
  const CompanySetupScreen({
    super.key,
    this.existingCompany,
  });

  @override
  State<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends State<CompanySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyService = CompanyService();
  
  // Controladores de texto
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  
  String _selectedSector = BusinessSector.sectors.first;
  CompanySize _selectedSize = CompanySize.pequena;
  DateTime _foundedDate = DateTime.now();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.existingCompany != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final company = widget.existingCompany!;
    _nameController.text = company.name;
    _descriptionController.text = company.description;
    _locationController.text = company.location;
    _websiteController.text = company.website ?? '';
    _phoneController.text = company.phone ?? '';
    _emailController.text = company.email ?? '';
    _addressController.text = company.address ?? '';
    _selectedSector = company.sector;
    _selectedSize = company.size;
    _foundedDate = company.foundedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingCompany == null ? 'Configurar Empresa' : 'Editar Empresa'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con logo
              Center(
                child: Column(
                  children: [
                    const TratoLogo(size: 80),
                    const SizedBox(height: 16),
                    Text(
                      widget.existingCompany == null 
                          ? '¡Configura tu empresa en TRATO!'
                          : 'Actualiza la información de tu empresa',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.existingCompany == null
                          ? 'Completa la información para crear tu perfil empresarial'
                          : 'Mantén actualizada la información de tu empresa',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Información básica
              _buildSectionTitle('Información Básica'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _nameController,
                label: 'Nombre de la Empresa',
                icon: Icons.business,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre de la empresa es requerido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _descriptionController,
                label: 'Descripción',
                icon: Icons.description,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es requerida';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Selector de sector
              _buildDropdownField(
                label: 'Sector',
                icon: Icons.category,
                value: _selectedSector,
                items: BusinessSector.sectors,
                onChanged: (value) {
                  setState(() {
                    _selectedSector = value!;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Selector de tamaño
              _buildDropdownField(
                label: 'Tamaño de Empresa',
                icon: Icons.people,
                value: _selectedSize.displayName,
                items: CompanySize.values.map((e) => e.displayName).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSize = CompanySize.values.firstWhere(
                      (size) => size.displayName == value,
                    );
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Información de contacto
              _buildSectionTitle('Información de Contacto'),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _locationController,
                label: 'Ubicación (Ciudad, País)',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La ubicación es requerida';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _addressController,
                label: 'Dirección Completa',
                icon: Icons.home,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _phoneController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _emailController,
                label: 'Email de Contacto',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _websiteController,
                label: 'Sitio Web',
                icon: Icons.language,
                keyboardType: TextInputType.url,
              ),
              
              const SizedBox(height: 24),
              
              // Fecha de fundación
              _buildSectionTitle('Información Adicional'),
              const SizedBox(height: 16),
              
              _buildDateField(),
              
              const SizedBox(height: 32),
              
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveCompany,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.existingCompany == null ? 'Crear Empresa' : 'Actualizar Empresa',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryBlue,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectFoundedDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fecha de Fundación',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '${_foundedDate.day}/${_foundedDate.month}/${_foundedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFoundedDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _foundedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _foundedDate = date;
      });
    }
  }

  Future<void> _saveCompany() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // TODO: Reemplazar lógica de usuario autenticado con tu sistema local
      final user = null; // O usa tu AuthService local
      
      final now = DateTime.now();
      
      if (widget.existingCompany == null) {
        // Crear nueva empresa
        final company = CompanyModel(
          id: '',
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          sector: _selectedSector,
          location: _locationController.text.trim(),
          website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
          foundedDate: _foundedDate,
          createdAt: now,
          updatedAt: now,
          ownerId: user.uid,
          size: _selectedSize,
        );
        
        await _companyService.createCompany(company);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Empresa creada exitosamente!'),
              backgroundColor: AppTheme.trustGreen,
            ),
          );
          Navigator.of(context).pop(true);
        }
      } else {
        // Actualizar empresa existente
        await _companyService.updateCompany(widget.existingCompany!.copyWith(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          location: _locationController.text.trim(),
          website: _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
          foundedDate: _foundedDate,
          size: _selectedSize,
          sector: _selectedSector,
          updatedAt: DateTime.now(),
        ));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Empresa actualizada exitosamente!'),
              backgroundColor: AppTheme.trustGreen,
            ),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
