// =====================================================================
// Point d'entrée principal de l'application Flutter.
// =====================================================================

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const GestionEtudiantsApp());
}

class GestionEtudiantsApp extends StatelessWidget {
  const GestionEtudiantsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Étudiants',
      debugShowCheckedModeBanner: false, // Retire la bannière de debug en haut à droite
      // Configuration d'un thème épuré avec Material 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // L'application démarre directement sur l'écran de connexion
      home: const LoginScreen(),
    );
  }
}