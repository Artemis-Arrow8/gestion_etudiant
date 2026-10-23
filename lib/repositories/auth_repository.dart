// =====================================================================
// Repository d'authentification
// =====================================================================

import '../services/auth_service.dart';
import '../models/student.dart';

class AuthRepository {
  Student? login(String email, String password) {
    bool success = AuthService.login(email, password);
    if (success) {
      return AuthService.currentStudent;
    }
    return null;
  }

  bool register({
    required String name,
    required String email,
    required String password,
    required String major,
  }) {
    return AuthService.register(
      name: name,
      email: email,
      password: password,
      major: major,
    );
  }

  void logout() {
    AuthService.logout();
  }
}