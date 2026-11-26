// =====================================================================
// Repository d'authentification et de session
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/student.dart';
import '../services/auth_service.dart';
import '../services/preferences_service.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository({
    AuthService? authService,
    PreferencesService? preferencesService,
  })  : _authService = authService ?? AuthService(),
        _preferences = preferencesService ?? PreferencesService();

  final AuthService _authService;
  final PreferencesService _preferences;

  // Étudiant actuellement connecté (null = personne n'est connecté)
  Student? _currentStudent;

  Student? get currentStudent => _currentStudent;
  bool get isLoggedIn => _currentStudent != null;

  /// Connecte l'étudiant.
  /// Si [rememberMe] est vrai, la session est mémorisée : l'étudiant
  /// restera connecté au prochain lancement de l'application.
  /// Renvoie l'étudiant connecté, ou `null` si les identifiants sont faux.
  Future<Student?> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final student = await _authService.authenticate(email, password);
    if (student == null) {
      return null; // Échec : on ne change rien à la session
    }

    // Enregistrement (ou non) de la session sur le téléphone
    if (rememberMe) {
      await _preferences.saveSessionStudentId(student.id);
    } else {
      await _preferences.clearSession();
    }

    _currentStudent = student;
    notifyListeners(); // Prévient AuthGate : on passe à l'accueil
    return student;
  }

  /// Restaure la session mémorisée au démarrage de l'application.
  Future<void> restoreSession() async {
    try {
      final studentId = await _preferences.readSessionStudentId();
      if (studentId == null) {
        return; // Aucune session enregistrée
      }

      _currentStudent = _authService.findStudentById(studentId);

      // Le compte n'existe plus : on efface la session devenue invalide
      if (_currentStudent == null) {
        await _preferences.clearSession();
      }
    } catch (e) {
      // En cas de problème de lecture, on démarre simplement déconnecté
      debugPrint('Impossible de restaurer la session : $e');
      _currentStudent = null;
    }
    notifyListeners();
  }

  /// Déconnecte l'étudiant et efface la session du téléphone.
  Future<void> logout() async {
    _currentStudent = null;
    try {
      await _preferences.clearSession();
    } catch (e) {
      debugPrint('Impossible d\'effacer la session : $e');
    }
    notifyListeners(); // Prévient AuthGate : retour à l'écran de connexion
  }
}
