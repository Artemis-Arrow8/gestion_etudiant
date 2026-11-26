// =====================================================================
// Modèle Grade — Une note obtenue dans un cours
// =====================================================================


class Grade {
  final String courseCode; // Code du cours évalué, ex. "MOB301"
  final String courseName; // Intitulé du cours évalué
  final double score; // Note sur 20
  final int coefficient; // Poids dans la moyenne (= crédits du cours)

  const Grade({
    required this.courseCode,
    required this.courseName,
    required this.score,
    required this.coefficient,
  });

  /// Note minimale pour valider un cours.
  static const double passingScore = 10;

  /// Vrai si le cours est validé.
  bool get isValidated => score >= passingScore;

  /// Moyenne générale pondérée (`null` s'il n'y a aucune note) :
  ///   moyenne = somme(note x coefficient) / somme(coefficients)
  static double? weightedAverage(List<Grade> grades) {
    double totalPoints = 0;
    int totalCoefficients = 0;
    for (final grade in grades) {
      totalPoints += grade.score * grade.coefficient;
      totalCoefficients += grade.coefficient;
    }
    return totalCoefficients > 0 ? totalPoints / totalCoefficients : null;
  }
}
