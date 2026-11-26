// =====================================================================
// Widget réutilisable — État "liste vide" ou "aucun résultat"
// =====================================================================

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  /// Message expliquant pourquoi il n'y a rien à afficher.
  final String message;

  /// Icône illustrant la situation.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
