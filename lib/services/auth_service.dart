import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream para escuchar cambios de autenticación
  Stream<User?> get user => _auth.authStateChanges();

  // ------------------- LOGIN -------------------
  Future<User?> login(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException('Error inesperado: $e');
    }
  }

  // ------------------- REGISTRO -------------------
  Future<User?> register(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Enviar verificación por email (opcional pero recomendado)
      await result.user?.sendEmailVerification();
      
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException('Error en el registro: $e');
    }
  }

  // ------------------- AUTENTICACIÓN CON GOOGLE -------------------
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        // El usuario canceló el proceso
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException('Error con Google Sign In: $e');
    }
  }

  // ------------------- AUTENTICACIÓN CON FACEBOOK -------------------
  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = 
            FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        // Once signed in, return the UserCredential
        final UserCredential result = await _auth.signInWithCredential(facebookAuthCredential);
        return result.user;
      } else if (loginResult.status == LoginStatus.cancelled) {
        // El usuario canceló el proceso
        return null;
      } else {
        throw AuthException('Error en Facebook Login: ${loginResult.message}');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getErrorMessage(e));
    } catch (e) {
      throw AuthException('Error con Facebook Sign In: $e');
    }
  }

  // ------------------- CERRAR SESIÓN -------------------
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  // ------------------- MANEJO DE ERRORES -------------------
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'user-disabled':
        return 'Cuenta deshabilitada';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'El correo ya está registrado';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde';
      default:
        return 'Error: ${e.message}';
    }
  }
}

// Clase personalizada para errores de autenticación
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}