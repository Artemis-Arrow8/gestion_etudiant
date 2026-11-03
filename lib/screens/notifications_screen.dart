// =====================================================================
// Écran des Notifications — Propulsé par l'API
// =====================================================================

import 'package:flutter/material.dart';
import '../services/notification_api_service.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<NotificationModel>> _futureNotifications;
  final NotificationApiService _apiService = NotificationApiService();

  @override
  void initState() {
    super.initState();
    _futureNotifications = _apiService.fetchNotifications();
  }

  void _retry() {
    setState(() {
      _futureNotifications = _apiService.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications & Annonces', style: TextStyle(color: AppColors.darkPlum)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkPlum),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.orchidPurple),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Impossible de charger les notifications.',
                      style: TextStyle(color: AppColors.darkPlum, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orchidPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'Aucune notification pour le moment.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
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
                        children: [
                          const Icon(Icons.notifications_active_outlined, color: AppColors.orchidPurple, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              notif.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.darkPlum),
                            ),
                          ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notif.message,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}