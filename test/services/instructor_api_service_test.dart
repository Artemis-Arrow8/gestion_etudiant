// =====================================================================
// Tests unitaires — Service API des enseignants (/users)
// =====================================================================


import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:gestion_etudiant/services/instructor_api_service.dart';

import '../helpers/fake_api.dart';

void main() {
  test('HTTP 200 avec liste : les utilisateurs deviennent des enseignants typés', () async {
    final service = InstructorApiService(client: fakeApiClient());

    final instructors = await service.fetchInstructors();

    expect(instructors.length, 10);
    expect(instructors.first.id, 1);
    expect(instructors.first.name, 'Leanne Graham');
    expect(instructors.first.email, 'Sincere@april.biz');
  });

  test('HTTP 200 avec [] : liste vide', () async {
    final client = MockClient((request) async => jsonResponse([]));

    expect(await InstructorApiService(client: client).fetchInstructors(), isEmpty);
  });

  test('HTTP 404 : une erreur est levée', () async {
    final client = MockClient((request) async => http.Response('Introuvable', 404));

    expect(InstructorApiService(client: client).fetchInstructors(), throwsException);
  });

  test('HTTP 500 : une erreur est levée', () async {
    final client = MockClient((request) async => http.Response('Erreur', 500));

    expect(InstructorApiService(client: client).fetchInstructors(), throwsException);
  });

  test('JSON invalide : une erreur est levée (pas de plantage silencieux)', () async {
    final client = MockClient((request) async => http.Response('pas du json', 200));

    expect(InstructorApiService(client: client).fetchInstructors(), throwsException);
  });

  test('Champ manquant dans la réponse : erreur de format', () async {
    final client = MockClient((request) async => jsonResponse([
          {'id': 1, 'name': 'Sans email'},
        ]));

    expect(InstructorApiService(client: client).fetchInstructors(), throwsFormatException);
  });

  test('Réseau indisponible : une erreur est levée', () async {
    final service = InstructorApiService(client: fakeApiClient(fail: true));

    expect(service.fetchInstructors(), throwsA(isA<http.ClientException>()));
  });

  test('Délai dépassé : TimeoutException', () async {
    // Le faux serveur répond trop tard par rapport au délai autorisé
    final client = MockClient((request) async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return jsonResponse(fakeUsers);
    });
    final service = InstructorApiService(
      client: client,
      timeout: const Duration(milliseconds: 20),
    );

    expect(service.fetchInstructors(), throwsA(isA<TimeoutException>()));
  });
}
