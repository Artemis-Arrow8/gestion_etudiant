// =====================================================================
// Tests unitaires — Service API des notifications (/posts)
// =====================================================================
// MockClient (fourni par le package http) remplace le vrai réseau.
// =====================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:gestion_etudiant/services/notification_api_service.dart';

import '../helpers/fake_api.dart';

void main() {
  test('HTTP 200 : les notifications sont décodées', () async {
    final client = MockClient((request) async => jsonResponse([
          {'id': 1, 'title': 'Annonce 1', 'body': 'Texte 1'},
          {'id': 2, 'title': 'Annonce 2', 'body': 'Texte 2'},
        ]));

    final notifications = await NotificationApiService(client: client).fetchNotifications();

    expect(notifications.length, 2);
    expect(notifications.first.title, 'Annonce 1');
    expect(notifications.first.message, 'Texte 1'); // "body" -> message
  });

  test('HTTP 200 avec [] : liste vide', () async {
    final client = MockClient((request) async => jsonResponse([]));

    expect(await NotificationApiService(client: client).fetchNotifications(), isEmpty);
  });

  test('HTTP 500 : une erreur est levée', () async {
    final client = MockClient((request) async => http.Response('Erreur', 500));

    expect(NotificationApiService(client: client).fetchNotifications(), throwsException);
  });

  test('JSON invalide : une erreur est levée', () async {
    final client = MockClient((request) async => http.Response('pas du json', 200));

    expect(NotificationApiService(client: client).fetchNotifications(), throwsException);
  });

  test('Réseau indisponible : une erreur est levée', () async {
    final service = NotificationApiService(client: fakeApiClient(fail: true));

    expect(service.fetchNotifications(), throwsA(isA<http.ClientException>()));
  });
}
