// =====================================================================
// Ce fichier gère la logique métier et l'état de l'écran de connexion (MVVM).
// =====================================================================

import 'package:flutter/material.dart';
import '../repositories/AuthRepository.dart';
import '../services/Auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Méthode pour lancer la connexion
  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Veuillez remplir tous les champs.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Appel au repository pour authentifier l'utilisateur
      final student = await _authRepository.authenticate(email, password);

      if (student != null) {
        // Enregistre l'étudiant connecté dans le service global
        AuthService.currentStudent = student;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email ou mot de passe incorrect.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Une erreur est survenue lors de la connexion.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}