// =====================================================================
// Validateurs des formulaires
// =====================================================================

class Validators {
  Validators._();

  // Format simple d'email : texte@domaine.extension
  static final RegExp _emailRegExp =
      RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  /// Longueur minimale acceptée pour un mot de passe.
  static const int minPasswordLength = 6;

  /// Vérifie que l'email est renseigné et a un format valide.
  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Veuillez saisir votre email';
    }
    if (!_emailRegExp.hasMatch(email)) {
      return 'Email invalide';
    }
    return null; // Saisie correcte
  }

  /// Vérifie que le mot de passe est renseigné et assez long.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }
    if (value.length < minPasswordLength) {
      return 'Le mot de passe doit contenir au moins $minPasswordLength caractères';
    }
    return null; // Saisie correcte
  }
}
