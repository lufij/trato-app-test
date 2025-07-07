import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Productos'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: const Center(
        child: Text('Gestión de productos en desarrollo.'),
      ),
    );
  }
}
