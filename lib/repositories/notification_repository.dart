// =====================================================================
// Repository des notifications — Fait le lien entre le service API et l'UI
// =====================================================================

import '../models/notification.dart';
import '../services/notification_api_service.dart';

class NotificationRepository {
  NotificationRepository({NotificationApiService? apiService})
      : _apiService = apiService ?? NotificationApiService();

  final NotificationApiService _apiService;

  /// Récupère les notifications depuis l'API.
  Future<List<NotificationModel>> getNotifications() => _apiService.fetchNotifications();

  /// Libère le client HTTP.
  void dispose() => _apiService.dispose();
}
