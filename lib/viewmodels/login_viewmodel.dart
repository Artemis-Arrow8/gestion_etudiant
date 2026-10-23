// =====================================================================
// ViewModel — Authentification 
// =====================================================================

import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../models/student.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  String? _errorMessage;
  Student? _currentStudent;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Student? get currentStudent => _currentStudent;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Petit délai simulé pour l'effet de chargement fluide
    await Future.delayed(const Duration(milliseconds: 400));

    final student = _authRepository.login(email, password);
    _isLoading = false;

    if (student != null) {
      _currentStudent = student;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Identifiants incorrects.';
      notifyListeners();
      return false;
    }
  }
}