// =====================================================================
// Repository des Cours — Fait le lien entre le service API et l'UI
// =====================================================================

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  CourseRepository({CourseApiService? apiService})
      : _apiService = apiService ?? CourseApiService();

  final CourseApiService _apiService;

  /// Récupère la liste des cours depuis le service API distant
  Future<List<Course>> getCourses() async {
    return await _apiService.fetchCourses();
  }
}