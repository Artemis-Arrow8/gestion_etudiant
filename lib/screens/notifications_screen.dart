// =====================================================================
// Écran des notifications — Données issues d'une API REST
// =====================================================================

import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../repositories/notification_repository.dart';
import '../utils/app_colors.dart';
import '../viewmodels/notifications_viewmodel.dart';
import '../viewmodels/view_status.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/responsive_body.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.repository});

  final NotificationRepository? repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _viewModel =
      NotificationsViewModel(repository: widget.repository);

  @override
  void initState() {
    super.initState();
    _viewModel.loadNotifications();
  }

  @override
  void dispose() {
    _viewModel.dispose(); // Ferme aussi le client HTTP
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ResponsiveBody(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_viewModel.status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const LoadingView(message: 'Chargement des notifications...');
      case ViewStatus.error:
        return ErrorView(
          message: _viewModel.errorMessage ?? 'Une erreur est survenue.',
          onRetry: _viewModel.loadNotifications,
        );
      case ViewStatus.empty:
        return const EmptyView(
          icon: Icons.notifications_none,
          message: 'Aucune notification pour le moment.',
        );
      case ViewStatus.success:
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _viewModel.notifications.length,
          itemBuilder: (context, index) =>
              _NotificationCard(notification: _viewModel.notifications[index]),
        );
    }
  }
}

/// Carte d'une notification.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textMain),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.message,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
