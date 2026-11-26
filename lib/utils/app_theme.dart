// =====================================================================
// Thème global de l'application
// =====================================================================

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Rayon des coins des champs, boutons et cartes.
  static const double _radius = 10;

  /// Thème clair utilisé par toute l'application.
  static ThemeData get light {
    // Bordure commune aux champs de saisie : fin contour gris doré
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(_radius),
      borderSide: const BorderSide(color: AppColors.border),
    );

    // Typographie Material de la plateforme (police Roboto sur Android).
    // Les styles du thème partent de cette base : ils héritent ainsi de la
    // bonne police au lieu d'un style "vide".
    final TextTheme textTheme = ThemeData(useMaterial3: true).textTheme;

    return ThemeData(
      useMaterial3: true,

      // Palette générée à partir de la couleur principale (noir)
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // Barre du haut : fond blanc, texte noir, sans ombre,
      // séparée du contenu par une fine ligne gris doré
      appBarTheme: AppBarThemeData(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textMain,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Champs de saisie : fond blanc, contour gris doré, noir quand actif
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: const TextStyle(color: AppColors.textMuted),
        prefixIconColor: AppColors.textMuted,
        suffixIconColor: AppColors.textMuted,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      // Boutons principaux : noirs, texte blanc semi-gras
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
          textStyle: textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Cartes : blanches, sans ombre, fine bordure gris doré
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius + 2),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Barre de navigation du bas : blanche, indicateur doré
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),

      // Séparateurs : gris doré
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }
}
