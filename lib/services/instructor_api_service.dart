// =====================================================================
// Service HTTP — Enseignants depuis l'API REST JSONPlaceholder (/users)
// =====================================================================


import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/instructor.dart';
import '../utils/app_constants.dart';
import 'http_client_factory.dart';

class InstructorApiService {
  /// [client] et [timeout] sont injectables pour les tests.
  InstructorApiService({http.Client? client, this.timeout = AppConstants.apiTimeout})
      : _client = client ?? HttpClientFactory.create();

  final http.Client _client;

  /// Temps maximum d'attente de la réponse.
  final Duration timeout;

  /// Récupère la liste des enseignants.
  Future<List<Instructor>> fetchInstructors() async {
    final response = await _client
        .get(Uri.parse(AppConstants.instructorsApiUrl), headers: {'Accept': 'application/json'})
        .timeout(timeout);

    // Vérification du code HTTP AVANT le décodage
    if (response.statusCode != 200) {
      throw Exception('Erreur HTTP ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Instructor.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Ferme le client HTTP pour libérer les ressources.
  void dispose() => _client.close();
}
