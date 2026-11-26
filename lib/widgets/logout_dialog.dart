// =====================================================================
// Boîte de dialogue réutilisable — Confirmation de déconnexion
// =====================================================================

import 'package:flutter/material.dart';

import '../viewmodels/session_viewmodel.dart';

Future<void> confirmLogout(BuildContext context, SessionViewModel session) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Déconnexion'),
      content: const Text('Voulez-vous vraiment vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Se déconnecter'),
        ),
      ],
    ),
  );

  // L'utilisateur a annulé, ou l'écran n'existe plus
  if (confirmed != true || !context.mounted) return;

  Navigator.of(context).popUntil((route) => route.isFirst);
  await session.logout();
}
