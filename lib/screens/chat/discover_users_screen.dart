import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DiscoverUsersScreen extends StatelessWidget {
  const DiscoverUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir Usuarios'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: Center(
        child: Text(
          'Pantalla para descubrir usuarios en desarrollo.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
