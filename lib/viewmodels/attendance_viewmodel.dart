// =====================================================================
// ViewModel — Vérification de présence sur le campus (géolocalisation)
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/geo_point.dart';
import '../services/location_service.dart';
import '../utils/app_constants.dart';
import 'base_viewmodel.dart';

/// États possibles de l'écran de présence.
enum AttendanceState {
  /// En attente : l'étudiant n'a pas encore lancé de vérification.
  idle,

  /// Vérification en cours (demande de permission, lecture du GPS).
  checking,

  /// L'étudiant est sur le campus.
  present,

  /// L'étudiant est hors du campus.
  absent,

  /// Permission refusée (on peut la redemander).
  permissionDenied,

  /// Permission refusée définitivement : fonctionnalité bloquée.
  permissionDeniedForever,

  /// Localisation du téléphone désactivée.
  serviceDisabled,

  /// Erreur inattendue (GPS trop long, etc.).
  error,
}

class AttendanceViewModel extends BaseViewModel {
  AttendanceViewModel({
    LocationService? locationService,
    this.campusLocation = AppConstants.campusLocation,
    this.campusRadiusMeters = AppConstants.campusRadiusMeters,
  }) : _locationService = locationService ?? LocationService();

  final LocationService _locationService;

  /// Position de référence du campus.
  final GeoPoint campusLocation;

  /// Rayon (en mètres) dans lequel l'étudiant est considéré présent.
  final double campusRadiusMeters;

  AttendanceState _state = AttendanceState.idle;
  double? _distanceInMeters;
  DateTime? _checkedAt;

  AttendanceState get state => _state;

  /// Distance entre l'étudiant et le campus lors de la dernière vérification.
  double? get distanceInMeters => _distanceInMeters;

  /// Heure de la dernière vérification réussie.
  DateTime? get checkedAt => _checkedAt;

  /// Vrai pendant une vérification (le bouton est alors désactivé).
  bool get isChecking => _state == AttendanceState.checking;

  /// Vrai si la fonctionnalité est bloquée par un refus définitif.
  bool get isFeatureBlocked =>
      _state == AttendanceState.permissionDeniedForever;

  /// Vérifie l'état de l'accès SANS afficher de demande.
  /// Appelé à l'ouverture de l'écran et au retour des paramètres.
  Future<void> refreshAccessStatus() async {
    // Pendant une vérification, la demande système met l'application en
    // pause puis la reprend : on ne doit pas interférer.
    if (isChecking) return;

    try {
      final access = await _locationService.checkAccess();

      switch (access) {
        case LocationAccess.deniedForever:
          _state = AttendanceState.permissionDeniedForever;
        case LocationAccess.serviceDisabled:
          _state = AttendanceState.serviceDisabled;
        case LocationAccess.granted:
        case LocationAccess.denied:
          // L'accès est (re)devenu possible : on débloque la fonctionnalité,
          // mais on garde un éventuel résultat de vérification déjà affiché.
          if (_state == AttendanceState.permissionDeniedForever ||
              _state == AttendanceState.serviceDisabled ||
              _state == AttendanceState.error) {
            _state = AttendanceState.idle;
          }
      }
    } catch (e) {
      debugPrint('Vérification de la permission impossible : $e');
    }
    notifyListeners();
  }

  /// Vérifie si l'étudiant se trouve sur le campus.
  Future<void> checkPresence() async {
    if (isChecking) return;

    _state = AttendanceState.checking;
    notifyListeners();

    try {
      // 1. Demande de permission (affichée seulement si nécessaire)
      final access = await _locationService.requestAccess();

      switch (access) {
        case LocationAccess.serviceDisabled:
          _state = AttendanceState.serviceDisabled;
          return;
        case LocationAccess.denied:
          _state = AttendanceState.permissionDenied;
          return;
        case LocationAccess.deniedForever:
          _state = AttendanceState.permissionDeniedForever;
          return;
        case LocationAccess.granted:
          break; // On peut continuer
      }

      // 2. Lecture de la position actuelle
      final position = await _locationService.getCurrentPosition();

      // 3. Calcul de la distance avec le campus
      _distanceInMeters =
          _locationService.distanceBetween(position, campusLocation);
      _checkedAt = DateTime.now();

      // 4. Présent si la distance est inférieure au rayon du campus
      _state = _distanceInMeters! <= campusRadiusMeters
          ? AttendanceState.present
          : AttendanceState.absent;
    } catch (e) {
      debugPrint('Erreur de géolocalisation : $e');
      _state = AttendanceState.error;
    } finally {
      // Exécuté même après un "return" dans le switch
      notifyListeners();
    }
  }

  /// Ouvre les bons paramètres du téléphone :
  /// - localisation du téléphone si le GPS est désactivé ;
  /// - autorisations de l'application sinon.
  /// Renvoie `false` si l'ouverture est impossible (ex. sur le web).
  Future<bool> openSettings() async {
    try {
      if (_state == AttendanceState.serviceDisabled) {
        return await _locationService.openLocationSettings();
      }
      return await _locationService.openAppSettings();
    } catch (e) {
      debugPrint('Ouverture des paramètres impossible : $e');
      return false;
    }
  }
}
