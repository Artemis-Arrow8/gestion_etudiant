// =====================================================================
// Tests unitaires — LoginViewModel
// =====================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestion_etudiant/repositories/auth_repository.dart';
import 'package:gestion_etudiant/services/auth_service.dart';
import 'package:gestion_etudiant/viewmodels/login_viewmodel.dart';

void main() {
  late AuthRepository repository;
  late LoginViewModel viewModel;

  // Identifiants du compte de démonstration (fictif)
  const email = 'awa.traore@etudiant.test';
  const password = 'Demo@2026';

  setUp(() {
    SharedPreferences.setMockInitialValues({}); // Stockage local vide
    repository = AuthRepository(
      authService: AuthService(simulatedDelay: Duration.zero),
    );
    viewModel = LoginViewModel(repository);
  });

  test('Connexion réussie avec les bons identifiants', () async {
    final success = await viewModel.login(email, password);

    expect(success, isTrue);
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.isLoading, isFalse);
    expect(repository.isLoggedIn, isTrue);
    expect(repository.currentStudent?.name, 'Awa Traoré');
  });

  test('Échec avec un mauvais mot de passe', () async {
    final success = await viewModel.login(email, 'mauvais-mdp');

    expect(success, isFalse);
    expect(viewModel.errorMessage, 'Email ou mot de passe incorrect.');
    expect(repository.isLoggedIn, isFalse);
  });

  test("L'email est accepté quelle que soit la casse", () async {
    final success = await viewModel.login('  Awa.Traore@Etudiant.TEST ', password);
    expect(success, isTrue);
  });

  test('"Se souvenir de moi" coché : la session est enregistrée', () async {
    viewModel.setRememberMe(true);
    await viewModel.login(email, password);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('session_student_id'), 'ETU-2026-0042');
  });

  test('"Se souvenir de moi" décoché : aucune session enregistrée', () async {
    viewModel.setRememberMe(false);
    await viewModel.login(email, password);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('session_student_id'), isNull);
  });
}
