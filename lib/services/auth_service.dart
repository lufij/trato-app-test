import '../models/user_model.dart';
import 'user_service.dart';
import 'dart:async';

class AuthService {
  final UserService _userService = UserService();
  UserModel? _currentUser;
  final StreamController<UserModel?> _userController = StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get user => _userController.stream;

  AuthService() {
    _userController.add(null);
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await _userService.loginLocal(email, password);
    if (user != null) {
      _currentUser = user;
      _userController.add(_currentUser);
      return _currentUser;
    }
    _userController.add(null);
    return null;
  }

  Future<UserModel?> register(String email, String password) async {
    UserService.addLocalUser(email: email, password: password);
    return await login(email, password);
  }

  Future<void> signOut() async {
    _currentUser = null;
    _userController.add(null);
  }

  UserModel? get currentUser => _currentUser;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}