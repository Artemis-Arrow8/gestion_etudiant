// =====================================================================
// Modèle Grade — Représente une note d'évaluation 
// =====================================================================

class Grade {
  final String courseName;
  final double score;
  final double coefficient;

  const Grade({
    required this.courseName,
    required this.score,
    required this.coefficient,
  });
}