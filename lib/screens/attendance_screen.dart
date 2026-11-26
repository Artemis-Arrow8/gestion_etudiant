// =====================================================================
// Écran "Présence sur le campus" — Fonctionnalité native
// =====================================================================

import 'package:flutter/material.dart';

import '../services/location_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../viewmodels/attendance_viewmodel.dart';
import '../widgets/message_banner.dart';
import '../widgets/responsive_body.dart';

class AttendanceScreen extends StatefulWidget {
  /// [locationService] permet d'injecter un faux service dans les tests.
  const AttendanceScreen({super.key, this.locationService});

  final LocationService? locationService;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late final AttendanceViewModel _viewModel =
      AttendanceViewModel(locationService: widget.locationService);

  // Surveille le cycle de vie de l'application (premier plan / arrière-plan)
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();

    // Quand l'application revient au premier plan (par exemple après être
    // passée par les paramètres du téléphone), on revérifie l'accès.
    _lifecycleListener = AppLifecycleListener(
      onResume: _viewModel.refreshAccessStatus,
    );

    // Vérification silencieuse à l'ouverture : aucune demande affichée,
    // mais si l'accès a été refusé définitivement, on l'indique tout de suite.
    _viewModel.refreshAccessStatus();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  /// Appui sur le bouton principal "Vérifier ma présence".
  Future<void> _onCheckPressed() async {
    // Fonctionnalité bloquée : on explique pourquoi au lieu de vérifier
    if (_viewModel.isFeatureBlocked) {
      await _showPermissionRequiredDialog();
      return;
    }

    await _viewModel.checkPresence();
    if (!mounted) return;

    // L'étudiant vient de refuser définitivement : on l'informe aussitôt
    if (_viewModel.isFeatureBlocked) {
      await _showPermissionRequiredDialog();
    }
  }

  /// Boîte de dialogue affichée quand la fonctionnalité est bloquée.
  Future<void> _showPermissionRequiredDialog() async {
    final bool? openSettings = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.location_off_outlined, color: AppColors.primary),
        title: const Text('Autorisation de localisation requise'),
        content: const Text(
          'Vous ne pouvez pas utiliser la vérification de présence car '
          'l\'application a besoin de votre position pour savoir si vous '
          'êtes sur le campus.\n\n'
          'Vous avez refusé l\'accès à la localisation et demandé à ne plus '
          'être sollicité(e). Pour utiliser cette fonctionnalité, autorisez '
          'la localisation dans les paramètres de l\'application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Plus tard'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ouvrir les paramètres'),
          ),
        ],
      ),
    );

    if (openSettings == true) {
      await _openSettings();
    }
  }

  /// Ouvre les paramètres du téléphone (autorisations ou localisation).
  Future<void> _openSettings() async {
    final bool opened = await _viewModel.openSettings();
    if (!opened && mounted) {
      // Ex. sur navigateur web : impossible d'ouvrir les paramètres
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible d\'ouvrir les paramètres : '
              'ouvrez-les manuellement depuis votre appareil.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Présence sur le campus')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ResponsiveBody(
          maxWidth: 560,
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildIntroCard(),
                const SizedBox(height: 20),
                _buildStatus(),
                const SizedBox(height: 20),
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Explication de la fonctionnalité et de l'usage de la position.
  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.accent),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppConstants.campusName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Vérifiez que vous êtes bien sur le campus (rayon de '
            '${AppConstants.campusRadiusMeters.round()} m). Votre position est '
            'utilisée uniquement pour ce calcul : elle n\'est ni enregistrée, '
            'ni envoyée sur internet.',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          const Text(
            'Simulation : les coordonnées du campus sont approximatives.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  /// Message affiché selon l'état du ViewModel.
  Widget _buildStatus() {
    final distance = _viewModel.distanceInMeters;
    final distanceText = distance == null ? '' : _formatDistance(distance);

    switch (_viewModel.state) {
      case AttendanceState.idle:
        return const MessageBanner(
          message: 'Appuyez sur « Vérifier ma présence ». L\'autorisation '
              'd\'accéder à votre position vous sera alors demandée.',
        );

      case AttendanceState.checking:
        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primary),
            ),
            SizedBox(width: 12),
            Text('Localisation en cours...', style: TextStyle(color: AppColors.textMuted)),
          ],
        );

      case AttendanceState.present:
        return MessageBanner(
          type: BannerType.success,
          title: 'Présence confirmée',
          message: 'Vous êtes sur le campus (à $distanceText du point de '
              'référence). Vérifié à ${_formatTime(_viewModel.checkedAt)}.',
        );

      case AttendanceState.absent:
        return MessageBanner(
          type: BannerType.warning,
          title: 'Hors du campus',
          message: 'Vous êtes à $distanceText du campus. Rapprochez-vous '
              'puis vérifiez de nouveau.',
        );

      case AttendanceState.permissionDenied:
        return const MessageBanner(
          type: BannerType.warning,
          title: 'Autorisation refusée',
          message: 'Pour vérifier votre présence, l\'application a besoin de '
              'votre position. Appuyez de nouveau sur « Vérifier ma présence » '
              'et choisissez « Autoriser ».',
        );

      case AttendanceState.permissionDeniedForever:
        return const MessageBanner(
          type: BannerType.error,
          title: 'Fonctionnalité indisponible',
          message: 'Vous ne pouvez pas utiliser cette fonctionnalité car elle a '
              'besoin de votre position, et l\'accès à la localisation a été '
              'refusé définitivement. Pour l\'utiliser, autorisez la '
              'localisation dans les paramètres. Le reste de l\'application '
              'fonctionne normalement.',
        );

      case AttendanceState.serviceDisabled:
        return const MessageBanner(
          type: BannerType.warning,
          title: 'Localisation désactivée',
          message: 'La localisation de votre appareil est désactivée. '
              'Activez-la pour vérifier votre présence.',
        );

      case AttendanceState.error:
        return const MessageBanner(
          type: BannerType.error,
          title: 'Position introuvable',
          message: 'Impossible d\'obtenir votre position pour le moment. '
              'Vérifiez votre signal GPS puis réessayez.',
        );
    }
  }

  /// Boutons d'action.
  Widget _buildActions() {
    final bool needsSettings = _viewModel.isFeatureBlocked ||
        _viewModel.state == AttendanceState.serviceDisabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Bouton principal : reste cliquable même si la fonctionnalité est
        // bloquée, pour pouvoir expliquer à l'étudiant pourquoi.
        ElevatedButton.icon(
          onPressed: _viewModel.isChecking ? null : _onCheckPressed,
          icon: Icon(_viewModel.isFeatureBlocked ? Icons.lock_outline : Icons.my_location),
          label: Text(_viewModel.isChecking ? 'Vérification...' : 'Vérifier ma présence'),
        ),
        if (needsSettings) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
            label: Text(
              _viewModel.state == AttendanceState.serviceDisabled
                  ? 'Activer la localisation'
                  : 'Ouvrir les paramètres',
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ],
    );
  }

  /// Affiche une distance lisible : "350 m" ou "2.4 km".
  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  /// Formate une heure : 14h05.
  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '${hours}h$minutes';
  }
}
