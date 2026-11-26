// =====================================================================
// Repository des cours — Point d'accès unique aux cours
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../services/instructor_api_service.dart';
import '../services/local_data_service.dart';

class CourseRepository {
  CourseRepository({
    LocalDataService? localData,
    InstructorApiService? apiService,
  })  : _localData = localData ?? LocalDataService(),
        _apiService = apiService ?? InstructorApiService();

  final LocalDataService _localData;
  final InstructorApiService _apiService;

  /// Catalogue local seul (sans appel réseau).
  /// Utilisé par le tableau de bord et pour relier les notes aux cours.
  Future<List<Course>> getCatalog() => _localData.loadCourseCatalog();

  /// Cours complets : catalogue local + nom de l'enseignant (API).
  ///
  /// Si l'API est injoignable (pas d'internet, erreur serveur...), les
  /// cours restent affichés sans le nom de l'enseignant : l'application
  /// ne dépend pas uniquement d'internet.
  Future<List<Course>> getCourses() async {
    final catalog = await getCatalog();

    try {
      final instructors = await _apiService.fetchInstructors();

      // Table "identifiant -> enseignant" pour retrouver chaque enseignant
      final byId = {for (final teacher in instructors) teacher.id: teacher};

      return catalog.map((course) {
        final teacher = byId[course.instructorId];
        return teacher == null ? course : course.withInstructor(teacher);
      }).toList();
    } catch (e) {
      // Détail technique en console uniquement
      debugPrint('Enseignants indisponibles : $e');
      return catalog;
    }
  }

  /// Libère le client HTTP.
  void dispose() => _apiService.dispose();
}
