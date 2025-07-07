import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacidad y Seguridad'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: const Center(
        child: Text('Configuración de privacidad en desarrollo.'),
      ),
    );
  }
}
