// =====================================================================
// Repository des notes
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/grade.dart';
import '../services/local_data_service.dart';

class GradeRepository {
  GradeRepository({LocalDataService? localData})
      : _localData = localData ?? LocalDataService();

  final LocalDataService _localData;

  /// Renvoie les notes de l'étudiant, dans l'ordre du catalogue.
  Future<List<Grade>> getGrades() async {
    final catalog = await _localData.loadCourseCatalog();
    final entries = await _localData.loadGradeEntries();

    final grades = <Grade>[];
    for (final course in catalog) {
      // Note de ce cours (un cours peut ne pas encore avoir de note)
      final matches = entries.where((entry) => entry.courseCode == course.code);
      if (matches.isEmpty) continue;

      grades.add(Grade(
        courseCode: course.code,
        courseName: course.title,
        score: matches.first.score,
        coefficient: course.credits,
      ));
    }

    // Sécurité : une note dont le cours n'existe pas est signalée en console
    final knownCodes = catalog.map((course) => course.code).toSet();
    for (final entry in entries) {
      if (!knownCodes.contains(entry.courseCode)) {
        debugPrint('Note ignorée : cours ${entry.courseCode} absent du catalogue');
      }
    }
    return grades;
  }
}
