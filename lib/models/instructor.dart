// =====================================================================
// Modèle Instructor — Un enseignant (données de l'API REST)
// =====================================================================


class Instructor {
  final int id; // Identifiant dans l'API (relié au champ instructorId d'un cours)
  final String name; // Nom complet de l'enseignant
  final String email; // Email de contact

  const Instructor({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Crée un enseignant à partir d'un objet JSON de l'API.
  /// Les champs sont vérifiés : une réponse incomplète lève une erreur
  /// claire au lieu de faire planter l'application plus loin.
  factory Instructor.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final email = json['email'];

    if (id is! int || name is! String || email is! String) {
      throw const FormatException('Enseignant : champ id, name ou email invalide');
    }
    return Instructor(id: id, name: name, email: email);
  }
}
