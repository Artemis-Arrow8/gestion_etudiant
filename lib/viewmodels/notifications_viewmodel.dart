// =====================================================================
// ViewModel — Notifications et annonces (API REST)
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/notification.dart';
import '../repositories/notification_repository.dart';
import 'base_viewmodel.dart';
import 'view_status.dart';

class NotificationsViewModel extends BaseViewModel {
  NotificationsViewModel({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository();

  final NotificationRepository _repository;

  ViewStatus _status = ViewStatus.initial;
  String? _errorMessage;
  List<NotificationModel> _notifications = [];

  ViewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<NotificationModel> get notifications => _notifications;

  /// Charge (ou recharge) les notifications depuis l'API.
  Future<void> loadNotifications() async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _repository.getNotifications();
      _status = _notifications.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      // Le détail technique reste en console : l'utilisateur ne voit
      // qu'un message compréhensible.
      debugPrint('Erreur de chargement des notifications : $e');
      _status = ViewStatus.error;
      _errorMessage = 'Impossible de charger les notifications. '
          'Vérifiez votre connexion internet puis réessayez.';
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.dispose(); // Ferme le client HTTP
    super.dispose();
  }
}
