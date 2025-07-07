import '../models/company_model.dart';

class CompanyService {
  // Simulación de base de datos local en memoria
  static final List<CompanyModel> _companies = [];

  // Crear una nueva empresa
  Future<CompanyModel> createCompany(CompanyModel company) async {
    final newCompany = company.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString());
    _companies.add(newCompany);
    return newCompany;
  }

  // Obtener una empresa por ID
  Future<CompanyModel?> getCompanyById(String id) async {
    try {
      return _companies.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // Obtener empresa por ID de propietario
  Future<CompanyModel?> getCompanyByOwnerId(String ownerId) async {
    try {
      return _companies.firstWhere((c) => c.ownerId == ownerId);
    } catch (_) {
      return null;
    }
  }

  // Actualizar empresa
  Future<void> updateCompany(CompanyModel company) async {
    final idx = _companies.indexWhere((c) => c.id == company.id);
    if (idx != -1) {
      _companies[idx] = company;
    }
  }

  // Eliminar empresa
  Future<void> deleteCompany(String id) async {
    _companies.removeWhere((c) => c.id == id);
  }
}
