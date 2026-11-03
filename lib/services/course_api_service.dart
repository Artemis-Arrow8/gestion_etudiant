// =====================================================================
// Service HTTP pour la récupération des cours depuis une API
// =====================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  // Injection optionnelle du client pour faciliter les tests unitaires
  CourseApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // URL de l'API (tu peux remplacer par ton API ou JSONPlaceholder)
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/users';

  /// Récupère la liste des cours via une requête HTTP GET sécurisée
  Future<List<Course>> fetchCourses() async {
    try {
      final uri = Uri.parse(_baseUrl);

      // Exécution de la requête avec un en-tête et un timeout de 10 secondes
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      // Vérification du code de statut HTTP avant tout décodage
      if (response.statusCode != 200) {
        throw Exception('Erreur HTTP : ${response.statusCode}');
      }

      // Décodage de la réponse JSON en liste dynamique
      final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;

      // Mapping de chaque élément JSON vers le modèle Course
      return decoded.map((item) {
        final json = item as Map<String, dynamic>;
        // Adaptation des champs de l'API de test vers notre modèle Course
        return Course(
          id: json['id'] as int,
          title: json['name'] as String, // Utilisation du nom comme titre pour l'exemple
          code: 'MOB${json['id']}01',
          instructor: json['email'] as String, // Utilisation de l'email comme enseignant pour l'exemple
        );
      }).toList();
    } catch (e) {
      throw Exception('Impossible de charger les cours : $e');
    }
  }

  // Fermeture du client HTTP pour libérer les ressources
  void dispose() => _client.close();
}