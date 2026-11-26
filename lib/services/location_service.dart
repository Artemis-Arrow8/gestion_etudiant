// =====================================================================
// Service de géolocalisation (fonctionnalité native)
// =====================================================================

import 'package:geolocator/geolocator.dart';

import '../models/geo_point.dart';
import '../utils/app_constants.dart';

/// État de l'accès à la position.
enum LocationAccess {
  /// L'application a le droit d'utiliser la position.
  granted,

  /// Permission refusée (ou pas encore demandée) : on peut la redemander.
  denied,

  /// Permission refusée DÉFINITIVEMENT ("Ne plus demander") : le système
  /// n'affichera plus la demande. Seul l'utilisateur peut la réactiver
  /// dans les paramètres du téléphone.
  deniedForever,

  /// La localisation (GPS) du téléphone est désactivée.
  serviceDisabled,
}

class LocationService {
  /// Vérifie l'accès SANS afficher de demande à l'utilisateur.
  /// Utilisé à l'ouverture de l'écran et au retour des paramètres.
  Future<LocationAccess> checkAccess() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    return _convert(await Geolocator.checkPermission());
  }

  /// Vérifie l'accès et, si besoin, AFFICHE la demande de permission.
  /// Doit être appelé uniquement quand l'utilisateur veut utiliser la
  /// fonctionnalité (au "moment pertinent", pas au démarrage de l'app).
  Future<LocationAccess> requestAccess() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // On ne peut demander que si la permission est simplement "refusée".
    // Si elle est refusée définitivement, le système ne montre plus rien.
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return _convert(permission);
  }

  /// Renvoie la position actuelle de l'appareil.
  Future<GeoPoint> getCurrentPosition() async {
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: AppConstants.locationTimeout,
      ),
    );
    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }

  /// Distance en mètres entre deux positions.
  double distanceBetween(GeoPoint from, GeoPoint to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Ouvre les paramètres de l'application (pour réactiver la permission).
  /// Renvoie `false` si la plateforme ne le permet pas (ex. navigateur web).
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  /// Ouvre les paramètres de localisation du téléphone (pour activer le GPS).
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  /// Convertit la permission du package en notre énumération.
  LocationAccess _convert(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationAccess.granted;
      case LocationPermission.deniedForever:
        return LocationAccess.deniedForever;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return LocationAccess.denied;
    }
  }
}
