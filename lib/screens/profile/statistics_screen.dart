import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: const Center(
        child: Text('Métricas de negocio en desarrollo.'),
      ),
    );
  }
}
