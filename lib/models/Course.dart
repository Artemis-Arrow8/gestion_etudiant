// =====================================================================
// Ce fichier représente le modèle d'un cours ou d'un module d'enseignement.
// =====================================================================

class Course {
  final String title;       // Titre du cours (ex: Développement Mobile)
  final String code;        // Code unique du module (ex: DEV401)
  final String instructor;  // Nom de l'enseignant responsable

  const Course({
    required this.title,
    required this.code,
    required this.instructor,
  });

  // Convertit l'objet Course en Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'code': code,
      'instructor': instructor,
    };
  }

  // Crée un objet Course à partir d'une Map
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      title: map['title'] ?? '',
      code: map['code'] ?? '',
      instructor: map['instructor'] ?? '',
    );
  }
}