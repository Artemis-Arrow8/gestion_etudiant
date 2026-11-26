// =====================================================================
// Mise en forme des nombres à la française
// =====================================================================

class Formatters {
  Formatters._();

  /// Écrit un nombre avec une virgule et sans zéros inutiles.
  /// Exemples : 13.7647 -> "13,76" ; 16.5 -> "16,5" ; 14.0 -> "14".
  static String decimal(double value, {int maxDigits = 2}) {
    String text = value.toStringAsFixed(maxDigits);
    if (text.contains('.')) {
      text = text.replaceFirst(RegExp(r'0+$'), ''); // Zéros de fin
      text = text.replaceFirst(RegExp(r'\.$'), ''); // Point final seul
    }
    return text.replaceAll('.', ',');
  }
}
