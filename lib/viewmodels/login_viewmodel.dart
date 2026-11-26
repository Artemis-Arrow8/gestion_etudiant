// =====================================================================
// ViewModel — Écran de connexion
// =====================================================================

import 'package:flutter/foundation.dart';

import '../repositories/auth_repository.dart';
import 'base_viewmodel.dart';

class LoginViewModel extends BaseViewModel {
  /// Le repository est fourni par l'écran (injection de dépendance).
  LoginViewModel(this._authRepository);

  final AuthRepository _authRepository;

  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  /// Coche / décoche "Se souvenir de moi".
  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// Tente la connexion. Renvoie `true` si elle a réussi.
  /// (Le formulaire a déjà été validé par l'écran avant cet appel.)
  Future<bool> login(String email, String password) async {
    // Évite de lancer deux connexions en même temps (double clic)
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // L'écran affiche l'indicateur de chargement

    try {
      final student = await _authRepository.login(
        email: email.trim(),
        password: password,
        rememberMe: _rememberMe,
      );

      if (student == null) {
        // Échec d'authentification : message volontairement général
        _errorMessage = 'Email ou mot de passe incorrect.';
        return false;
      }
      return true;
    } catch (e) {
      // Erreur inattendue : détail technique dans la console seulement
      debugPrint('Erreur de connexion : $e');
      _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
      return false;
    } finally {
      // Exécuté dans tous les cas (succès, échec ou erreur)
      _isLoading = false;
      notifyListeners();
    }
  }
}
