// =====================================================================
// Tests unitaires — CourseRepository (catalogue local + API)
// =====================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_etudiant/repositories/course_repository.dart';
import 'package:gestion_etudiant/services/instructor_api_service.dart';

import '../helpers/fake_api.dart';

void main() {
  // Nécessaire pour lire les fichiers assets/data/*.json dans un test
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Chaque cours reçoit son enseignant grâce à instructorId', () async {
    final repository = CourseRepository(
      apiService: InstructorApiService(client: fakeApiClient()),
    );

    final courses = await repository.getCourses();

    final mobile = courses.firstWhere((course) => course.code == 'MOB301');
    expect(mobile.title, 'Développement mobile avancé');
    expect(mobile.instructor, 'Leanne Graham'); // instructorId 1
    expect(mobile.instructorEmail, 'Sincere@april.biz');
    expect(courses.every((course) => course.instructor != null), isTrue);
  });

  test('API injoignable : les cours restent disponibles, sans enseignant', () async {
    final repository = CourseRepository(
      apiService: InstructorApiService(client: fakeApiClient(fail: true)),
    );

    final courses = await repository.getCourses();

    expect(courses, isNotEmpty); // Le catalogue local suffit
    expect(courses.every((course) => course.instructor == null), isTrue);
  });
}
