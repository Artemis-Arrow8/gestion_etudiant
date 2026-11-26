// =====================================================================
// ViewModel — Session de l'étudiant connecté
// =====================================================================

import '../models/student.dart';
import '../repositories/auth_repository.dart';

class SessionViewModel {
  SessionViewModel(this._authRepository);

  final AuthRepository _authRepository;

  /// Étudiant connecté (null si personne n'est connecté).
  Student? get student => _authRepository.currentStudent;

  /// Déconnecte l'étudiant. L'AuthGate affichera alors l'écran de
  /// connexion automatiquement.
  Future<void> logout() => _authRepository.logout();
}
