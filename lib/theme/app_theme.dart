import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales de TRATO
  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color accentGreen = Color(0xFF34A853);
  static const Color accentOrange = Color(0xFFFF9800); // Naranja profesional
  static const Color trustGreen = Color(0xFF43A047); // Verde confianza
  static const Color elegantGray = Color(0xFF444444);
  static const Color lightGray = Color(0xFFF5F6FA);
  static const Color gold = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF43A047);
  static const Color darkGray = Color(0xFF222222); // Gris oscuro

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: elegantGray,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: lightGray,
      labelStyle: const TextStyle(color: elegantGray),
      helperStyle: const TextStyle(color: elegantGray, fontSize: 12),
      errorStyle: const TextStyle(color: errorRed),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightGray,
      selectedColor: accentGreen.withOpacity(0.2),
      labelStyle: const TextStyle(color: elegantGray),
      secondaryLabelStyle: const TextStyle(color: primaryBlue),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: primaryBlue,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold, color: elegantGray, fontSize: 22),
      bodyLarge: TextStyle(color: elegantGray, fontSize: 16),
      bodyMedium: TextStyle(color: elegantGray, fontSize: 14),
    ),
  );

  // Gradientes personalizados
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient trustGradient = LinearGradient(
    colors: [accentGreen, Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras personalizadas
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
