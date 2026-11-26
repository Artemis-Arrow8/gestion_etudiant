// =====================================================================
// Service de persistance locale — Mémorisation de la session
// =====================================================================


import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Clé utilisée dans le stockage local
  static const String _sessionKey = 'session_student_id';

  /// Mémorise le matricule de l'étudiant connecté.
  Future<void> saveSessionStudentId(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, studentId);
  }

  /// Lit le matricule mémorisé (ou `null` s'il n'y a pas de session).
  Future<String?> readSessionStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey);
  }

  /// Supprime la session (lors de la déconnexion).
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
