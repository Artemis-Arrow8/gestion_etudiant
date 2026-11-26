// =====================================================================
// Widget réutilisable — Bandeau de message coloré
// =====================================================================

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Type de message : détermine la couleur et l'icône.
enum BannerType { info, success, warning, error }

class MessageBanner extends StatelessWidget {
  const MessageBanner({
    super.key,
    required this.message,
    this.type = BannerType.info,
    this.title,
  });

  final String message;
  final BannerType type;

  /// Titre facultatif affiché en gras au-dessus du message.
  final String? title;

  @override
  Widget build(BuildContext context) {
    // Choix des couleurs et de l'icône selon le type de message
    final (Color background, Color foreground, IconData icon) = switch (type) {
      BannerType.info => (AppColors.infoBackground, AppColors.textMain, Icons.info_outline),
      BannerType.success => (AppColors.successBackground, AppColors.successText, Icons.check_circle_outline),
      BannerType.warning => (AppColors.warningBackground, AppColors.warningText, Icons.warning_amber_rounded),
      BannerType.error => (AppColors.errorBackground, AppColors.errorText, Icons.error_outline),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(color: foreground, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(message, style: TextStyle(color: foreground)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
