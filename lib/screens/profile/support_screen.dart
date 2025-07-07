import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soporte'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: const Center(
        child: Text('Sección de ayuda y contacto en desarrollo.'),
      ),
    );
  }
}
