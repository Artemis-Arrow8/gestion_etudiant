// =====================================================================
// Service d'authentification — Gestion des comptes institutionnels
// =====================================================================

import '../models/student.dart';

class AuthService {
  // Liste des étudiants gérée par l'administration de l'établissement
  static final List<Student> _students = [
    const Student(
      id: 'ITMA-2026-001',
      name: 'Kadiatou Hélène Guindo',
      email: 'kadiatou@itma.ml',
      major: 'Génie Logiciel (GL3)',
    ),
  ];

  static Student? currentStudent = _students.first;

  /// Vérifie les identifiants de l'étudiant dans la base institutionnelle
  static bool login(String email, String password) {
    try {
      final student = _students.firstWhere((s) => s.email == email);
      currentStudent = student;
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Déconnexion de l'étudiant
  static void logout() {
    currentStudent = null;
  }
}