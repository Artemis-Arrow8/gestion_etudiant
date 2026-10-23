// =====================================================================
// Écran des Notifications 
// =====================================================================

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NotificationItem {
  final String title;
  final String message;
  final String date;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.date,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<NotificationItem> notifications = const [
    NotificationItem(
      title: 'Publication des notes',
      message: 'Les notes du module de Développement Mobile Avancé sont en ligne.',
      date: 'Aujourd\'hui, 10:30',
    ),
    NotificationItem(
      title: 'Changement de salle',
      message: 'Le cours de Génie Logiciel aura lieu en salle TP2.',
      date: 'Hier, 14:15',
    ),
    NotificationItem(
      title: 'Réunion pédagogique',
      message: 'Rappel : Réunion d\'information pour les étudiants de L3 ce vendredi.',
      date: '16 Oct 2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: AppColors.textMain)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text('Aucune notification pour le moment.', style: TextStyle(color: AppColors.textMuted)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  color: AppColors.surface,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notif.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain),
                            ),
                            Text(
                              notif.date,
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notif.message,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}