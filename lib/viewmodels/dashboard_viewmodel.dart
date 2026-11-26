// =====================================================================
// ViewModel — Tableau de bord (indicateurs et cours récents)
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../models/grade.dart';
import '../repositories/course_repository.dart';
import '../repositories/grade_repository.dart';
import '../repositories/notification_repository.dart';
import '../utils/app_constants.dart';
import 'base_viewmodel.dart';
import 'view_status.dart';

class DashboardViewModel extends BaseViewModel {
  DashboardViewModel({
    CourseRepository? courseRepository,
    GradeRepository? gradeRepository,
    NotificationRepository? notificationRepository,
  })  : _courseRepository = courseRepository ?? CourseRepository(),
        _gradeRepository = gradeRepository ?? GradeRepository(),
        _notificationRepository = notificationRepository ?? NotificationRepository();

  final CourseRepository _courseRepository;
  final GradeRepository _gradeRepository;
  final NotificationRepository _notificationRepository;

  ViewStatus _status = ViewStatus.initial;
  List<Course> _courses = [];
  double? _average;
  int? _notificationCount;
  bool _notificationsLoading = false;

  ViewStatus get status => _status;

  /// Vrai pendant l'appel à l'API des notifications.
  bool get notificationsLoading => _notificationsLoading;

  /// Indicateur 1 : nombre de cours suivis.
  int get courseCount => _courses.length;

  /// Indicateur 2 : moyenne générale pondérée (null si aucune note).
  double? get average => _average;

  /// Indicateur 3 : nombre de notifications (null si l'API est injoignable).
  int? get notificationCount => _notificationCount;

  /// Premiers cours du catalogue, affichés dans « Mes cours récents ».
  List<Course> get recentCourses =>
      _courses.take(AppConstants.recentCoursesCount).toList();

  /// Charge les indicateurs.
  Future<void> load() async {
    _status = ViewStatus.loading;
    notifyListeners();

    try {
      // Données locales : cours et notes (disponibles hors connexion)
      _courses = await _courseRepository.getCatalog();
      _average = Grade.weightedAverage(await _gradeRepository.getGrades());
      _status = ViewStatus.success;
    } catch (e) {
      debugPrint('Erreur de chargement du tableau de bord : $e');
      _status = ViewStatus.error;
      notifyListeners();
      return;
    }

    // Les données locales s'affichent tout de suite, sans attendre l'API
    _notificationsLoading = true;
    notifyListeners();

    // Données de l'API : une panne réseau ne bloque pas le tableau de bord,
    // seul l'indicateur des notifications affiche « — ».
    try {
      _notificationCount = (await _notificationRepository.getNotifications()).length;
    } catch (e) {
      debugPrint('Notifications indisponibles : $e');
      _notificationCount = null;
    }
    _notificationsLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _courseRepository.dispose(); // Ferme les clients HTTP
    _notificationRepository.dispose();
    super.dispose();
  }
}
