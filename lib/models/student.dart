// =====================================================================
// FICHIER : lib/models/student.dart
// RÔLE : Modèle représentant un étudiant avec ses informations de base.
// =====================================================================

class Student {
  final String id;        // Identifiant unique de l'étudiant
  final String name;      // Nom complet de l'étudiant
  final String email;     // Adresse email (utilisée pour la connexion)
  final String password;  // Mot de passe du compte
  final String major;     // Filière universitaire (ex: Génie Logiciel)

  // Constructeur pour initialiser un objet Student
  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.major,
  });

  // Convertit l'objet Student en Map (pratique si tu veux enregistrer en JSON/base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'major': major,
    };
  }

  // Crée un objet Student à partir d'une Map de données
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      major: map['major'] ?? '',
    );
  }
}