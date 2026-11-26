// =====================================================================
// Service de données locales — Jeu de données JSON de l'application
// =====================================================================


import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course.dart';
import '../utils/app_constants.dart';

class LocalDataService {
  /// [bundle] est facultatif : les tests peuvent fournir d'autres fichiers.
  LocalDataService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  /// Charge le catalogue des cours.
  Future<List<Course>> loadCourseCatalog() async {
    final List<dynamic> items = await _loadJsonList(AppConstants.coursesAsset);
    return items.map((item) => Course.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// Charge les notes : une liste de couples (code du cours, note sur 20).
  Future<List<({String courseCode, double score})>> loadGradeEntries() async {
    final List<dynamic> items = await _loadJsonList(AppConstants.gradesAsset);
    return items.map((item) {
      final json = item as Map<String, dynamic>;
      final code = json['courseCode'];
      final score = json['score'];
      if (code is! String || score is! num) {
        throw const FormatException('Note : champ courseCode ou score invalide');
      }
      return (courseCode: code, score: score.toDouble());
    }).toList();
  }

  /// Lit un fichier JSON contenant une liste.
  /// cache: false — les fichiers sont petits ; on les relit à chaque fois,
  /// ce qui évite aussi de garder une ancienne version en mémoire.
  Future<List<dynamic>> _loadJsonList(String assetPath) async {
    final String text = await _bundle.loadString(assetPath, cache: false);
    return jsonDecode(text) as List<dynamic>;
  }
}
