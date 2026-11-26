// =====================================================================
// Widget réutilisable — État "chargement en cours"
// =====================================================================

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message = 'Chargement...'});

  /// Texte affiché sous l'indicateur.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
