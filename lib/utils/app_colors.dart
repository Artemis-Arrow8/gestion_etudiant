// =====================================================================
// Palette de Couleurs 
// =====================================================================

import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales issues de ta palette
  static const Color darkPlum = Color(0xFF4D3A4D);       // Prune foncé (#4D3A4D) - Titres et texte principal
  static const Color orchidPurple = Color(0xFFBE5CA9);   // Violet orchidée (#BE5CA9) - Boutons et actions principales
  static const Color softLilac = Color(0xFFD59CC5);      // Lilas doux (#D59CC5) - Éléments secondaires et puces
  static const Color paleBackground = Color(0xFFEADADA); // Fond très pâle (#EADADA) - Arrière-plan global
  
  // Rétrocompatibilité pour les écrans existants (évite les erreurs sur accentSage et primaryPink)
  static const Color accentSage = Color(0xFFD4E0D2);     // Vert sauge apaisant
  static const Color primaryPink = Color(0xFFD59CC5);    // Équivalent poudré pour les boutons/fonds
  
  // Fonds et Surfaces pour un design moderne et épuré
  static const Color background = Color(0xFFEADADA);     // Fond général de l'application
  static const Color surface = Color(0xFFFFFFFF);         // Blanc pur pour les cartes (Cards) et conteneurs
  
  // Typographie (Contrastes optimisés avec le prune foncé)
  static const Color textMain = Color(0xFF4D3A4D);        // Texte principal (Prune foncé)
  static const Color textMuted = Color(0xFF7A6A7A);       // Gris-mauve atténué pour les sous-titres
  
  // Actions, Alertes et États sémantiques
  static const Color buttonBackground = Color(0xFFBE5CA9); // Fond des boutons principaux (Orchidée)
  static const Color errorBackground = Color(0xFFFFD1D1);  // Rose pastel pour les erreurs
  static const Color successBackground = Color(0xFFD4E0D2); // Vert pastel pour les validations
}