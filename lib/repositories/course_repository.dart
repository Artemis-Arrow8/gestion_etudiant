// =====================================================================
// Repository des Cours — Gestion centralisée des données des cours
// =====================================================================

import '../models/course.dart';

class CourseRepository {
  // Liste statique simulant notre base de données ou le retour d'une API
  static const List<Course> _allCourses = [
    Course(
      title: 'Développement mobile avancé',
      code: 'MOB301',
      instructor: 'Mme Traoré',
    ),
    Course(
      title: 'Génie logiciel et UML',
      code: 'GEN302',
      instructor: 'M. Diallo',
    ),
    Course(
      title: 'Bases de données relationnelles',
      code: 'BDD303',
      instructor: 'Dr Coulibaly',
    ),
    Course(
      title: 'Réseaux informatiques',
      code: 'RES304',
      instructor: 'M. Sidibé',
    ),
    Course(
      title: 'Systèmes d\'exploitation',
      code: 'SYST305',
      instructor: 'Mme Guindo',
    ),
  ];

  /// Récupère la liste complète des cours disponibles
  /// Simule une requête asynchrone pour préparer l'intégration d'une API future
  Future<List<Course>> getCourses() async {
    // Petit délai simulé pour imiter un appel réseau
    await Future.delayed(const Duration(milliseconds: 300));
    return _allCourses;
  }
}