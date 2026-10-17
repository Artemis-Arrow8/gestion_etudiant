// =====================================================================
// Ce fichier représente le modèle d'une note obtenue par l'étudiant.
// =====================================================================

class Grade {
  final String courseName;  // Nom de la matière
  final double score;       // Note obtenue (sur 20 par exemple)
  final double coefficient; // Coefficient du module

  const Grade({
    required this.courseName,
    required this.score,
    required this.coefficient,
  });

  // Convertit l'objet Grade en Map (pour les bases de données ou JSON)
  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'score': score,
      'coefficient': coefficient,
    };
  }

  // Crée un objet Grade à partir d'une Map avec conversion sécurisée des types
  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      courseName: map['courseName'] ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      coefficient: (map['coefficient'] as num?)?.toDouble() ?? 1.0,
    );
  }
}