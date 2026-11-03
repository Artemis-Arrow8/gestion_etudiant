// =====================================================================
// Modèle Course — Représente un cours avec conversion JSON
// =====================================================================

class Course {
  final int id;
  final String title;
  final String code;
  final String instructor;

  const Course({
    required this.id,
    required this.title,
    required this.code,
    required this.instructor,
  });

  // Constructeur factory pour créer un objet Course à partir d'une map JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      title: json['title'] as String? ?? 'Cours sans titre',
      code: json['code'] as String? ?? 'MOD000',
      instructor: json['instructor'] as String? ?? 'Enseignant non spécifié',
    );
  }
}