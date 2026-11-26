// =====================================================================
// Point d'entrée de l'application
// =====================================================================

import 'package:flutter/material.dart';

import 'repositories/auth_repository.dart';
import 'screens/auth_gate.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Un seul AuthRepository pour toute l'application : il garde en
  // mémoire l'étudiant connecté.
  final authRepository = AuthRepository();
  await authRepository.restoreSession();

  runApp(GestionEtudiantsApp(authRepository: authRepository));
}

class GestionEtudiantsApp extends StatelessWidget {
  const GestionEtudiantsApp({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Étudiants',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // L'AuthGate choisit le premier écran selon l'état de la session
      home: AuthGate(authRepository: authRepository),
    );
  }
}
