// =====================================================================
// Service HTTP — Récupération des notifications depuis l'API JSONPlaceholder
// =====================================================================

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notification.dart';
import '../utils/app_constants.dart';
import 'http_client_factory.dart';

class NotificationApiService {
  /// [client] et [timeout] sont injectables pour les tests.
  NotificationApiService({http.Client? client, this.timeout = AppConstants.apiTimeout})
      : _client = client ?? HttpClientFactory.create();

  final http.Client _client;

  /// Temps maximum d'attente de la réponse.
  final Duration timeout;

  /// Récupère la liste des notifications via une requête HTTP GET.
  Future<List<NotificationModel>> fetchNotifications() async {
    // Requête avec un en-tête et un délai maximum
    final response = await _client
        .get(Uri.parse(AppConstants.notificationsApiUrl), headers: {'Accept': 'application/json'})
        .timeout(timeout);

    // Vérification du code HTTP AVANT le décodage
    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }

    // Décodage du JSON et conversion en objets NotificationModel
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Ferme le client HTTP pour libérer les ressources.
  void dispose() => _client.close();
}
