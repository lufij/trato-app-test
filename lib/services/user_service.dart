import '../models/user_model.dart';

class UserService {
  // Mapa de usuarios locales
  static final Map<String, UserModel> _localUsers = {
    'admin': UserModel(
      id: 'admin',
      email: 'admin',
      name: 'Administrador',
      userType: UserType.productor, // Puedes cambiar el tipo si lo deseas
      createdAt: DateTime.now(),
      isVerified: true,
      trustScore: 100.0,
      company: 'AdminCorp',
      profileImage: null,
      phone: null,
      location: null,
      description: 'Usuario administrador',
    ),
  };

  // Crear usuario local registrado
  static void addLocalUser({required String email, required String password}) {
    _localUsers[email] = UserModel(
      id: email,
      email: email,
      name: 'Guicho Interiano',
      userType: UserType.vendedor,
      createdAt: DateTime.now(),
      isVerified: true,
      trustScore: 80.0,
      company: 'Usuario Local',
      profileImage: null,
      phone: null,
      location: null,
      description: 'Usuario registrado localmente',
    );
  }

  // Agregar usuario local registrado al cargar el servicio
  UserService() {
    addLocalUser(email: 'guichointeriano@yahoo.com', password: 'Foto2301');
  }

  // Obtener perfil de usuario local
  Future<UserModel?> getUserProfile(String uid) async {
    return _localUsers[uid];
  }

  // Actualizar perfil de usuario local
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    final user = _localUsers[uid];
    if (user != null) {
      _localUsers[uid] = user.copyWith(
        name: data['name'] ?? user.name,
        company: data['company'] ?? user.company,
        phone: data['phone'] ?? user.phone,
        location: data['location'] ?? user.location,
        description: data['description'] ?? user.description,
        profileImage: data['profileImage'] ?? user.profileImage,
      );
    } else {
      throw Exception('Usuario no encontrado');
    }
  }

  // Método para validar usuario local
  Future<UserModel?> loginLocal(String email, String password) async {
    if (_localUsers.containsKey(email) && password == 'Foto2301') {
      return _localUsers[email];
    }
    if (email == 'admin' && password == 'admin') {
      return _localUsers['admin'];
    }
    return null;
  }
}