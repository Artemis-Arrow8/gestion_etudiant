// =====================================================================
// Palette de couleurs de l'application
// =====================================================================

import 'package:flutter/material.dart';

class AppColors {
  // Constructeur privé : cette classe ne contient que des constantes,
  // on ne doit donc jamais en créer d'instance.
  AppColors._();

  // --- Couleurs principales de la charte graphique ---
  static const Color primary = Color(0xFF111111); // Noir : boutons, actions, avatar
  static const Color accent = Color(0xFFB08D2E); // Or ancien : icônes et accents
  static const Color primaryLight = Color(0xFFD4AF37); // Or clair : indicateurs, contours
  static const Color primarySoft = Color(0xFFFBF6E6); // Crème doré : carte de moyenne

  // --- Fonds, surfaces et bordures ---
  static const Color background = Color(0xFFFAFAFA); // Blanc cassé : fond des écrans
  static const Color surface = Color(0xFFFFFFFF); // Blanc : cartes et conteneurs
  static const Color border = Color(0xFFE8E4D8); // Gris doré très pâle : bordures fines

  // --- Texte ---
  static const Color textMain = Color(0xFF111111); // Noir : titres et texte
  static const Color textMuted = Color(0xFF6B6B6B); // Gris : textes secondaires

  // --- Couleurs de statut (succès / erreur / avertissement / info) ---
  static const Color successBackground = Color(0xFFF6F0DC); // Crème or
  static const Color successText = Color(0xFF6E5410); // Bronze
  static const Color errorBackground = Color(0xFFFBEAEA); // Rouge très pâle
  static const Color errorText = Color(0xFFA32020); // Rouge foncé
  static const Color warningBackground = Color(0xFFFFF4E0); // Ambre pâle
  static const Color warningText = Color(0xFF8A5300); // Ambre foncé
  static const Color infoBackground = Color(0xFFF4F4F4); // Gris très clair
}
