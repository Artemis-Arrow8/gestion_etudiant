// =====================================================================
// Tests de widgets — Parcours de l'application
// =====================================================================


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gestion_etudiant/main.dart';
import 'package:gestion_etudiant/models/course.dart';
import 'package:gestion_etudiant/repositories/auth_repository.dart';
import 'package:gestion_etudiant/repositories/course_repository.dart';
import 'package:gestion_etudiant/screens/courses_screen.dart';
import 'package:gestion_etudiant/services/auth_service.dart';
import 'package:gestion_etudiant/services/http_client_factory.dart';
import 'package:gestion_etudiant/utils/app_theme.dart';

import 'helpers/fake_api.dart';

/// Faux repository des cours pour tester l'écran seul.
class FakeCourseRepository implements CourseRepository {
  FakeCourseRepository(this.courses);

  final List<Course> courses;

  @override
  Future<List<Course>> getCatalog() async => courses;

  @override
  Future<List<Course>> getCourses() async => courses;

  @override
  void dispose() {}
}

void main() {
  setUp(() {
    // Stockage local vide (aucune session enregistrée)
    SharedPreferences.setMockInitialValues({});
    // Les appels HTTP de l'application passent par le faux serveur
    HttpClientFactory.create = fakeApiClient;
  });
  tearDown(() => HttpClientFactory.create = http.Client.new);

  // Écran de téléphone (390 x 844) : barre de navigation en bas
  void tailleTelephone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  // Application de test : authentification simulée SANS délai d'attente
  Widget creerApplication() {
    final repository = AuthRepository(
      authService: AuthService(simulatedDelay: Duration.zero),
    );
    return GestionEtudiantsApp(authRepository: repository);
  }

  // Petites fonctions pour retrouver les éléments de l'écran
  Finder champEmail() => find.widgetWithText(TextFormField, 'Email institutionnel');
  Finder champMotDePasse() => find.widgetWithText(TextFormField, 'Mot de passe');
  Finder boutonConnexion() => find.widgetWithText(ElevatedButton, 'Se connecter');
  Finder ongletNavigation(String libelle) =>
      find.descendant(of: find.byType(NavigationBar), matching: find.text(libelle));

  // Appuie sur "Se connecter" puis attend la fin des animations
  Future<void> appuyerSurConnexion(WidgetTester tester) async {
    await tester.ensureVisible(boutonConnexion());
    await tester.tap(boutonConnexion());
    await tester.pumpAndSettle();
  }

  // Connexion avec le compte de démonstration (fictif, documenté dans le README)
  Future<void> seConnecter(WidgetTester tester) async {
    await tester.pumpWidget(creerApplication());
    await tester.enterText(champEmail(), 'awa.traore@etudiant.test');
    await tester.enterText(champMotDePasse(), 'Demo@2026');
    await appuyerSurConnexion(tester);
  }

  testWidgets("L'application démarre sur l'écran de connexion", (tester) async {
    await tester.pumpWidget(creerApplication());

    expect(find.text('Connexion Étudiante'), findsOneWidget);
    expect(champEmail(), findsOneWidget);
    expect(champMotDePasse(), findsOneWidget);
    expect(boutonConnexion(), findsOneWidget);
  });

  testWidgets('T1 — Se connecter sans remplir les champs : messages de validation', (tester) async {
    await tester.pumpWidget(creerApplication());

    await appuyerSurConnexion(tester); // Aucun champ rempli

    expect(find.text('Veuillez saisir votre email'), findsOneWidget);
    expect(find.text('Veuillez saisir votre mot de passe'), findsOneWidget);
  });

  testWidgets('T2 — Email sans @ : format incorrect signalé', (tester) async {
    await tester.pumpWidget(creerApplication());

    await tester.enterText(champEmail(), 'awa.traore.etudiant.test');
    await tester.enterText(champMotDePasse(), 'Demo@2026');
    await appuyerSurConnexion(tester);

    expect(find.text('Email invalide'), findsOneWidget);
  });

  testWidgets('Identifiants incorrects : message d\'erreur, on reste sur la connexion', (tester) async {
    await tester.pumpWidget(creerApplication());

    await tester.enterText(champEmail(), 'inconnu@etudiant.test');
    await tester.enterText(champMotDePasse(), 'mauvais-mot-de-passe');
    await appuyerSurConnexion(tester);

    expect(find.text('Email ou mot de passe incorrect.'), findsOneWidget);
    expect(find.text('Connexion Étudiante'), findsOneWidget);
  });

  testWidgets('T3 — Valeurs valides : le tableau de bord s\'ouvre avec ses indicateurs', (tester) async {
    tailleTelephone(tester);
    await seConnecter(tester);

    expect(find.text('Connexion Étudiante'), findsNothing);
    expect(find.text('Tableau de bord'), findsOneWidget);
    expect(find.text('Bonjour, Awa !'), findsOneWidget);
    // Trois indicateurs : cours, notes, notifications
    expect(find.text('Cours suivis'), findsOneWidget);
    expect(find.text('Moyenne'), findsOneWidget);
    expect(find.text('Notifications'), findsWidgets);
    expect(find.text('Mes cours récents'), findsOneWidget);
  });

  testWidgets('T4 — Ouvrir Mes cours : les cours sont visibles avec leur enseignant', (tester) async {
    tailleTelephone(tester);
    await seConnecter(tester);

    await tester.tap(ongletNavigation('Cours'));
    await tester.pumpAndSettle();

    expect(find.text('Mes cours'), findsOneWidget);
    expect(find.text('Développement mobile avancé'), findsOneWidget);
    expect(find.text('MOB301 · 4 crédits'), findsOneWidget);
    expect(find.text('Leanne Graham'), findsOneWidget); // Enseignant venu de l'API
  });

  testWidgets('T5 — Titre très long : aucun débordement, l\'action reste visible', (tester) async {
    // Petit téléphone de 320 px de large
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    const longTitle = 'Méthodologie de la recherche scientifique appliquée au '
        'développement d\'applications mobiles multiplateformes et sécurisées';
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: CoursesScreen(
        repository: FakeCourseRepository(const [
          Course(code: 'MET307', title: longTitle, credits: 2, instructorId: 7, instructor: 'Kurtis Weissnat'),
        ]),
        onShowGrades: () {},
      ),
    ));
    await tester.pumpAndSettle();

    // Un débordement ferait échouer le test avec une exception
    expect(tester.takeException(), isNull);
    final action = find.text('Voir les notes');
    expect(action, findsOneWidget);
    expect(tester.getRect(action).right, lessThanOrEqualTo(320));
  });

  testWidgets('T6 — Revenir au tableau de bord : la navigation reste claire', (tester) async {
    tailleTelephone(tester);
    await seConnecter(tester);

    await tester.tap(ongletNavigation('Cours'));
    await tester.pumpAndSettle();
    await tester.tap(ongletNavigation('Accueil'));
    await tester.pumpAndSettle();

    expect(find.text('Tableau de bord'), findsOneWidget);
    expect(find.text('Mes cours récents'), findsOneWidget);
  });

  testWidgets('« Voir les notes » ouvre l\'onglet Notes avec la moyenne', (tester) async {
    tailleTelephone(tester);
    await seConnecter(tester);

    await tester.tap(ongletNavigation('Cours'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voir les notes').first);
    await tester.pumpAndSettle();

    expect(find.text('Mes notes'), findsOneWidget);
    expect(find.text('Moyenne générale pondérée'), findsOneWidget);
    expect(find.text('13,76 / 20'), findsOneWidget); // 234 / 17
  });
}
