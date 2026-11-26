// =====================================================================
// Constantes de configuration de l'application
// =====================================================================

import '../models/geo_point.dart';

class AppConstants {
  AppConstants._();

  // -------------------------------------------------------------------
  // API REST JSONPlaceholder (API publique de démonstration)
  // -------------------------------------------------------------------

  /// Enseignants des cours : la route /users (utilisateurs fictifs).
  static const String instructorsApiUrl =
      'https://jsonplaceholder.typicode.com/users';

  /// Notifications : la route /posts (contenu factice, en latin).
  static const String notificationsApiUrl =
      'https://jsonplaceholder.typicode.com/posts?_limit=8';

  /// Temps maximum d'attente d'une réponse de l'API.
  static const Duration apiTimeout = Duration(seconds: 10);

  // -------------------------------------------------------------------
  // Jeu de données local (documenté dans docs/donnees.md)
  // -------------------------------------------------------------------

  /// Catalogue des cours : code, intitulé, crédits, enseignant (id API).
  static const String coursesAsset = 'assets/data/courses.json';

  /// Notes de l'étudiant, reliées aux cours par leur code.
  static const String gradesAsset = 'assets/data/grades.json';

  /// Nombre de cours affichés dans « Mes cours récents » (tableau de bord).
  static const int recentCoursesCount = 3;

  // -------------------------------------------------------------------
  // Géolocalisation : vérification de la présence sur le campus.
  // SIMULATION : les coordonnées ci-dessous sont APPROXIMATIVES (centre
  // de Bamako). Pour un vrai déploiement, il faudrait mettre les
  // coordonnées exactes du campus.
  // -------------------------------------------------------------------
  static const String campusName = 'Campus ENI-ABT (Bamako)';
  static const GeoPoint campusLocation =
      GeoPoint(latitude: 12.6392, longitude: -8.0029);

  /// Rayon (en mètres) dans lequel l'étudiant est considéré "sur le campus".
  static const double campusRadiusMeters = 500;

  /// Temps maximum pour obtenir la position GPS.
  static const Duration locationTimeout = Duration(seconds: 15);

  // -------------------------------------------------------------------
  // Mise en page adaptative (téléphone / tablette / web)
  // -------------------------------------------------------------------

  /// Au-delà de cette largeur, on affiche un menu latéral (NavigationRail)
  /// au lieu de la barre de navigation du bas.
  static const double wideLayoutBreakpoint = 600;

  /// Largeur maximale du contenu : évite des lignes trop longues
  /// sur les grands écrans.
  static const double maxContentWidth = 760;
}
