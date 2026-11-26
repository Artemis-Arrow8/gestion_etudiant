// =====================================================================
// Modèle Course — Un cours du catalogue de l'étudiant
// =====================================================================

import 'instructor.dart';

class Course {
  final String code; // Code du module, ex. "MOB301" (identifiant unique)
  final String title; // Intitulé du cours
  final int credits; // Nombre de crédits (sert aussi de coefficient)
  final int instructorId; // Identifiant de l'enseignant dans l'API
  final String? instructor; // Nom de l'enseignant (null si l'API est injoignable)
  final String? instructorEmail; // Email de l'enseignant (null si inconnu)

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.instructorId,
    this.instructor,
    this.instructorEmail,
  });

  /// Crée un cours à partir d'une entrée du catalogue local (JSON).
  factory Course.fromJson(Map<String, dynamic> json) {
    final code = json['code'];
    final title = json['title'];
    final credits = json['credits'];
    final instructorId = json['instructorId'];

    if (code is! String || title is! String || credits is! int || instructorId is! int) {
      throw const FormatException('Cours : champ code, title, credits ou instructorId invalide');
    }
    return Course(code: code, title: title, credits: credits, instructorId: instructorId);
  }

  /// Renvoie une copie du cours complétée avec son enseignant.
  Course withInstructor(Instructor teacher) {
    return Course(
      code: code,
      title: title,
      credits: credits,
      instructorId: instructorId,
      instructor: teacher.name,
      instructorEmail: teacher.email,
    );
  }
}
