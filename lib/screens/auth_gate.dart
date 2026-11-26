// =====================================================================
// AuthGate — "Portail" de l'application selon la session
// =====================================================================

import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder reconstruit son contenu à chaque notifyListeners()
    return ListenableBuilder(
      listenable: authRepository,
      builder: (context, _) {
        if (authRepository.isLoggedIn) {
          return HomeScreen(authRepository: authRepository);
        }
        return LoginScreen(authRepository: authRepository);
      },
    );
  }
}
