// =====================================================================
// Service d'authentification — AUTHENTIFICATION SIMULÉE
// =====================================================================

import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/student.dart';

/// Un compte de démonstration : l'étudiant + l'empreinte de son mot de passe.
class _DemoAccount {
  final Student student;
  final String passwordHash;

  const _DemoAccount({required this.student, required this.passwordHash});
}

class AuthService {
  /// [simulatedDelay] imite le temps de réponse d'un vrai serveur
  /// (on peut le mettre à zéro dans les tests).
  AuthService({this.simulatedDelay = const Duration(milliseconds: 700)});

  final Duration simulatedDelay;

  // Comptes de démonstration (fictifs). Le mot de passe du compte est
  // indiqué dans le README ; ici on ne garde que son empreinte SHA-256.
  static const List<_DemoAccount> _accounts = [
    _DemoAccount(
      student: Student(
        id: 'ETU-2026-0042',
        name: 'Awa Traoré',
        email: 'awa.traore@etudiant.test',
        major: 'Génie Logiciel',
        level: 'Licence 3',
      ),
      passwordHash:
          '6269bdc44514c668efb1ee9442d68ac81c662367fa36c1883e3027ee197f4036',
    ),
  ];

  /// Vérifie les identifiants.
  /// Renvoie l'étudiant si l'email ET le mot de passe sont corrects,
  /// sinon `null`.
  Future<Student?> authenticate(String email, String password) async {
    // On simule le délai d'un appel réseau
    await Future.delayed(simulatedDelay);

    // L'email n'est pas sensible à la casse ni aux espaces autour
    final normalizedEmail = email.trim().toLowerCase();
    final passwordHash = hashPassword(password);

    for (final account in _accounts) {
      final sameEmail = account.student.email == normalizedEmail;
      final samePassword = account.passwordHash == passwordHash;
      if (sameEmail && samePassword) {
        return account.student;
      }
    }
    // Message volontairement identique que l'email ou le mot de passe
    // soit faux : on ne révèle pas quels emails existent.
    return null;
  }

  /// Retrouve un étudiant à partir de son matricule.
  /// Sert à restaurer la session enregistrée sur le téléphone.
  Student? findStudentById(String id) {
    for (final account in _accounts) {
      if (account.student.id == id) {
        return account.student;
      }
    }
    return null;
  }

  /// Calcule l'empreinte SHA-256 d'un mot de passe (en hexadécimal).
  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
