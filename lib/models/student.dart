// =====================================================================
// Modèle Student — Représente un étudiant 
// =====================================================================

class Student {
  final String id;
  final String name;
  final String email;
  final String major;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
  });
}