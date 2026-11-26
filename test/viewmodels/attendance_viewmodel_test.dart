// =====================================================================
// Tests unitaires — AttendanceViewModel (géolocalisation et permission)
// =====================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_etudiant/models/geo_point.dart';
import 'package:gestion_etudiant/services/location_service.dart';
import 'package:gestion_etudiant/viewmodels/attendance_viewmodel.dart';

/// Faux service de localisation entièrement contrôlé par le test.
class FakeLocationService implements LocationService {
  LocationAccess accessOnCheck = LocationAccess.denied; // Vérification silencieuse
  LocationAccess accessOnRequest = LocationAccess.granted; // Après la demande
  double distance = 100; // Distance renvoyée (en mètres)
  bool gpsFails = false;

  int requestCount = 0; // Nombre de demandes de permission affichées
  bool appSettingsOpened = false;
  bool locationSettingsOpened = false;

  @override
  Future<LocationAccess> checkAccess() async => accessOnCheck;

  @override
  Future<LocationAccess> requestAccess() async {
    requestCount++;
    return accessOnRequest;
  }

  @override
  Future<GeoPoint> getCurrentPosition() async {
    if (gpsFails) throw Exception('GPS indisponible');
    return const GeoPoint(latitude: 0, longitude: 0);
  }

  @override
  double distanceBetween(GeoPoint from, GeoPoint to) => distance;

  @override
  Future<bool> openAppSettings() async => appSettingsOpened = true;

  @override
  Future<bool> openLocationSettings() async => locationSettingsOpened = true;
}

void main() {
  late FakeLocationService location;
  late AttendanceViewModel viewModel;

  setUp(() {
    location = FakeLocationService();
    viewModel = AttendanceViewModel(locationService: location, campusRadiusMeters: 500);
  });

  group('Vérification de présence', () {
    test('Présent si la distance est dans le rayon du campus', () async {
      location.distance = 120;

      await viewModel.checkPresence();

      expect(viewModel.state, AttendanceState.present);
      expect(viewModel.distanceInMeters, 120);
      expect(viewModel.checkedAt, isNotNull);
    });

    test('Absent si la distance dépasse le rayon', () async {
      location.distance = 2500;

      await viewModel.checkPresence();

      expect(viewModel.state, AttendanceState.absent);
    });

    test('Erreur GPS : état "error"', () async {
      location.gpsFails = true;

      await viewModel.checkPresence();

      expect(viewModel.state, AttendanceState.error);
    });
  });

  group('Gestion de la permission', () {
    test("La permission n'est pas demandée à l'ouverture de l'écran", () async {
      await viewModel.refreshAccessStatus();

      expect(location.requestCount, 0);
      expect(viewModel.state, AttendanceState.idle);
    });

    test('Refus simple : message, mais la fonctionnalité reste utilisable', () async {
      location.accessOnRequest = LocationAccess.denied;

      await viewModel.checkPresence();

      expect(viewModel.state, AttendanceState.permissionDenied);
      expect(viewModel.isFeatureBlocked, isFalse);
    });

    test('Refus définitif : la fonctionnalité est bloquée', () async {
      location.accessOnRequest = LocationAccess.deniedForever;

      await viewModel.checkPresence();

      expect(viewModel.state, AttendanceState.permissionDeniedForever);
      expect(viewModel.isFeatureBlocked, isTrue);
    });

    test("Refus définitif déjà connu : bloqué dès l'ouverture, sans demande", () async {
      location.accessOnCheck = LocationAccess.deniedForever;

      await viewModel.refreshAccessStatus();

      expect(viewModel.isFeatureBlocked, isTrue);
      expect(location.requestCount, 0);
    });

    test('Bloqué : le bouton ouvre les paramètres de l\'application', () async {
      location.accessOnRequest = LocationAccess.deniedForever;
      await viewModel.checkPresence();

      await viewModel.openSettings();

      expect(location.appSettingsOpened, isTrue);
    });

    test('Autorisation donnée dans les paramètres : fonctionnalité débloquée', () async {
      // 1. Au départ, la fonctionnalité est bloquée
      location.accessOnCheck = LocationAccess.deniedForever;
      await viewModel.refreshAccessStatus();
      expect(viewModel.isFeatureBlocked, isTrue);

      // 2. L'étudiant autorise la localisation puis revient dans l'app
      location.accessOnCheck = LocationAccess.granted;
      await viewModel.refreshAccessStatus();

      expect(viewModel.isFeatureBlocked, isFalse);
      expect(viewModel.state, AttendanceState.idle);
    });

    test('GPS désactivé : propose les paramètres de localisation', () async {
      location.accessOnRequest = LocationAccess.serviceDisabled;

      await viewModel.checkPresence();
      await viewModel.openSettings();

      expect(viewModel.state, AttendanceState.serviceDisabled);
      expect(location.locationSettingsOpened, isTrue);
    });
  });
}
