// =====================================================================
// Service API pour les Notifications et Annonces de l'Université
// =====================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationModel {
  final int id;
  final String title;
  final String message;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Annonce officielle',
      message: json['body'] as String? ?? 'Aucun détail fourni.',
    );
  }
}

class NotificationApiService {
  NotificationApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  // Utilisation d'une route API de test pour simuler les flux de notifications
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts?_limit=5';

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await _client
          .get(Uri.parse(_baseUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }

      final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
      return decoded.map((item) => NotificationModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Impossible de charger les notifications : $e');
    }
  }

  void dispose() => _client.close();
}