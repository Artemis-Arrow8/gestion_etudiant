// =====================================================================
// Tests unitaires — Cohérence du jeu de données local
// =====================================================================


import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_etudiant/repositories/grade_repository.dart';
import 'package:gestion_etudiant/services/local_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final localData = LocalDataService();

  test('Le catalogue contient au moins 5 cours complets et sans doublon', () async {
    final courses = await localData.loadCourseCatalog();

    expect(courses.length, greaterThanOrEqualTo(5));
    for (final course in courses) {
      expect(course.code, isNotEmpty);
      expect(course.title, isNotEmpty);
      expect(course.credits, greaterThan(0));
    }
    final codes = courses.map((course) => course.code).toSet();
    expect(codes.length, courses.length); // Codes uniques
  });

  test('Chaque note correspond à un cours du catalogue', () async {
    final courses = await localData.loadCourseCatalog();
    final entries = await localData.loadGradeEntries();
    final codes = courses.map((course) => course.code).toSet();

    for (final entry in entries) {
      expect(codes, contains(entry.courseCode));
      expect(entry.score, inInclusiveRange(0, 20));
    }
  });

  test('Les notes reprennent l\'intitulé et les crédits du cours', () async {
    final courses = await localData.loadCourseCatalog();
    final grades = await GradeRepository(localData: localData).getGrades();

    expect(grades, isNotEmpty);
    for (final grade in grades) {
      final course = courses.firstWhere((course) => course.code == grade.courseCode);
      expect(grade.courseName, course.title);
      expect(grade.coefficient, course.credits);
    }
  });
}
