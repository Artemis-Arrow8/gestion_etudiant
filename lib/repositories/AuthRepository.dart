// =====================================================================
// Ce fichier gère la source des données d'authentification.
// =====================================================================

import '../models/Student.dart';

class AuthRepository {
  // Simule une requête réseau ou un accès à une base de données avec un délai
  Future<Student?> authenticate(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation d'une latence

    // Vérification des identifiants (tu pourras connecter une vraie base de données plus tard)
    if (email == 'kadi@itma.ml' && password == 'password123') {
      return const Student(
        id: '1',
        name: 'Kadiatou Guindo',
        email: email,
        password: password,
        major: 'Génie Logiciel',
      );
    }
    return null; // Retourne null si l'authentification échoue
  }
}