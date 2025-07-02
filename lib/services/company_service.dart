import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/company_model.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'companies';

  // Crear una nueva empresa
  Future<CompanyModel> createCompany(CompanyModel company) async {
    try {
      final docRef = await _firestore.collection(_collection).add(company.toMap());
      return company.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Error al crear la empresa: $e');
    }
  }

  // Obtener una empresa por ID
  Future<CompanyModel?> getCompanyById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return CompanyModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener la empresa: $e');
    }
  }

  // Obtener empresa por ID de propietario
  Future<CompanyModel?> getCompanyByOwnerId(String ownerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('ownerId', isEqualTo: ownerId)
          .limit(1)
          .get();
      
      if (query.docs.isNotEmpty) {
        return CompanyModel.fromMap({
          ...query.docs.first.data(),
          'id': query.docs.first.id
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener la empresa: $e');
    }
  }

  // Actualizar una empresa
  Future<void> updateCompany(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar la empresa: $e');
    }
  }

  // Verificar una empresa
  Future<void> verifyCompany(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isVerified': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al verificar la empresa: $e');
    }
  }

  // Agregar imagen a la galería
  Future<void> addToGallery(String companyId, String imageUrl) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'gallery': FieldValue.arrayUnion([imageUrl]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al agregar imagen a la galería: $e');
    }
  }

  // Eliminar imagen de la galería
  Future<void> removeFromGallery(String companyId, String imageUrl) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'gallery': FieldValue.arrayRemove([imageUrl]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al eliminar imagen de la galería: $e');
    }
  }

  // Actualizar horario de negocio
  Future<void> updateBusinessHours(String companyId, Map<String, dynamic> hours) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'businessHours': hours,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar horario: $e');
    }
  }

  // Agregar certificación
  Future<void> addCertification(String companyId, String certification) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'certifications': FieldValue.arrayUnion([certification]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al agregar certificación: $e');
    }
  }

  // Buscar empresas por sector
  Future<List<CompanyModel>> getCompaniesBySector(String sector) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('sector', isEqualTo: sector)
          .get();
      
      return query.docs
          .map((doc) => CompanyModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar empresas por sector: $e');
    }
  }

  // Buscar empresas verificadas
  Future<List<CompanyModel>> getVerifiedCompanies() async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('isVerified', isEqualTo: true)
          .get();
      
      return query.docs
          .map((doc) => CompanyModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar empresas verificadas: $e');
    }
  }

  // Incrementar seguidores
  Future<void> incrementFollowers(String companyId) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'followers': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al incrementar seguidores: $e');
    }
  }

  // Decrementar seguidores
  Future<void> decrementFollowers(String companyId) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'followers': FieldValue.increment(-1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al decrementar seguidores: $e');
    }
  }

  // Actualizar ubicación
  Future<void> updateLocation(String companyId, double latitude, double longitude, String address) async {
    try {
      await _firestore.collection(_collection).doc(companyId).update({
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar ubicación: $e');
    }
  }
}
