// =====================================================================
// Le Service gérant la liste des étudiants inscrits et la session active.
// =====================================================================

import '../models/student.dart';

class AuthService {
  // Liste statique agissant comme une base de données locale temporaire
  static final List<Student> _registeredStudents = [
    // Un compte par défaut pré-intégré pour tester tout de suite
    const Student(
      id: '1',
      name: 'Kadiatou Guindo',
      email: 'kadi@itma.ml',
      password: 'password123',
      major: 'Génie Logiciel',
    ),
  ];

  // Stocke l'étudiant actuellement connecté (null si personne n'est connecté)
  static Student? currentStudent;

  // Méthode pour inscrire un nouvel étudiant
  static bool register({
    required String name,
    required String email,
    required String password,
    required String major,
  }) {
    // Vérifie si l'email existe déjà dans la liste
    bool emailExists = _registeredStudents.any((student) => student.email == email);
    if (emailExists) {
      return false; // Échec : l'email est déjà pris
    }

    // Crée un nouvel étudiant avec un ID unique basé sur l'heure actuelle
    final newStudent = Student(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      major: major,
    );

    // Ajoute l'étudiant à la liste
    _registeredStudents.add(newStudent);
    
    // Connecte automatiquement l'étudiant après son inscription
    currentStudent = newStudent;
    return true;
  }

  // Méthode pour connecter un étudiant existant de manière sécurisée
  static bool login(String email, String password) {
    try {
      // Utilisation de .firstWhere avec un orElse pour éviter les plantages (StateError)
      final student = _registeredStudents.firstWhere(
        (s) => s.email == email && s.password == password,
        orElse: () => throw Exception('Utilisateur non trouvé'),
      );
      currentStudent = student; // Mémorise la session active
      return true;
    } catch (e) {
      return false; // Échec : identifiants incorrects
    }
  }

  // Méthode pour déconnecter l'utilisateur
  static void logout() {
    currentStudent = null;
  }
}