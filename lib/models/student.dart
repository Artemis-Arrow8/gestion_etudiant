// =====================================================================
// Modèle Student — Représente un étudiant
// =====================================================================

class Student {
  final String id; // Matricule de l'étudiant
  final String name; // Nom complet
  final String email; // Email institutionnel (sert d'identifiant)
  final String major; // Filière, ex. "Génie Logiciel"
  final String level; // Niveau d'études, ex. "Licence 3"

  const Student({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.level,
  });

  /// Initiale affichée dans l'avatar (ex. "A" pour "Awa Traoré").
  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';

  /// Prénom seul, utilisé pour le message de bienvenue.
  String get firstName => name.split(' ').first;
}
