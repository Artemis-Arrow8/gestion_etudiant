// =====================================================================
// Service d'authentification 
// =====================================================================

import '../models/student.dart';

class AuthService {
  static final List<Student> _students = [
    const Student(
      id: 'ITMA-2026-001',
      name: 'Kadiatou Hélène Guindo',
      email: 'kadiatou@itma.ml',
      major: 'Génie Logiciel (GL3)',
    ),
  ];

  static Student? currentStudent = _students.first;

  static bool login(String email, String password) {
    try {
      final student = _students.firstWhere((s) => s.email == email);
      currentStudent = student;
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool register({
    required String name,
    required String email,
    required String password,
    required String major,
  }) {
    if (_students.any((s) => s.email == email)) {
      return false;
    }

    final newStudent = Student(
      id: 'ITMA-2026-00${_students.length + 1}',
      name: name,
      email: email,
      major: major,
    );

    _students.add(newStudent);
    currentStudent = newStudent;
    return true;
  }

  static void logout() {
    currentStudent = null;
  }
}