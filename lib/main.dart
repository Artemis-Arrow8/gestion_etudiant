// =====================================================================
// Point d'entrée principal de l'application Flutter.
// =====================================================================

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const GestionEtudiantsApp());
}

class GestionEtudiantsApp extends StatelessWidget {
  const GestionEtudiantsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Étudiants',
      debugShowCheckedModeBanner: false, 
      
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.orchidPurple,
          primary: AppColors.orchidPurple,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto', // Ou la police par défaut
      ),
      // L'application démarre directement sur l'écran de connexion
      home: const LoginScreen(),
    );
  }
}