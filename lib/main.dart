import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/main_navigation_screen.dart';
import 'models/user_model.dart';
import 'services/local_database_service.dart';
import 'services/persistence_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDatabaseService.init();
  // Detectar modo de persistencia solo una vez
  try {
    await FirebaseFirestore.instance.collection('posts').limit(1).get();
    PersistenceConfig.mode = PersistenceMode.firebase;
    print('Modo de persistencia: Firebase');
  } catch (e) {
    PersistenceConfig.mode = PersistenceMode.local;
    print('Modo de persistencia: Local. Error: ' + e.toString());
  }
  runApp(const TratoApp());
}

class TratoApp extends StatelessWidget {
  const TratoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TRATO',
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: null, // Aquí va tu stream de usuarios
      builder: (context, snapshot) {
        // Mientras se verifica el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.lightGray,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.handshake,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'TRATO',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Red Social de Negocios',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.elegantGray,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        
        // Si hay un usuario autenticado
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigation();
        }
        
        // Si no hay usuario autenticado, mostrar registro
        return const RegisterScreen();
      },
    );
  }
}
