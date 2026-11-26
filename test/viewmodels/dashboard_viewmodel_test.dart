// =====================================================================
// Tests unitaires — DashboardViewModel (indicateurs du tableau de bord)
// =====================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_etudiant/repositories/course_repository.dart';
import 'package:gestion_etudiant/repositories/notification_repository.dart';
import 'package:gestion_etudiant/services/instructor_api_service.dart';
import 'package:gestion_etudiant/services/notification_api_service.dart';
import 'package:gestion_etudiant/viewmodels/dashboard_viewmodel.dart';
import 'package:gestion_etudiant/viewmodels/view_status.dart';

import '../helpers/fake_api.dart';

/// Tableau de bord branché sur le vrai jeu de données local et sur un
/// faux serveur (qui fonctionne, ou qui est en panne si [apiFails]).
DashboardViewModel createViewModel({bool apiFails = false}) {
  return DashboardViewModel(
    courseRepository: CourseRepository(
      apiService: InstructorApiService(client: fakeApiClient(fail: apiFails)),
    ),
    notificationRepository: NotificationRepository(
      apiService: NotificationApiService(client: fakeApiClient(fail: apiFails)),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Trois indicateurs : cours, moyenne et notifications', () async {
    final viewModel = createViewModel();

    await viewModel.load();

    expect(viewModel.status, ViewStatus.success);
    expect(viewModel.courseCount, 6);
    // (16,5x4 + 14x3 + 15x4 + 9,5x3 + 12,5x3) / 17 = 234 / 17
    expect(viewModel.average, closeTo(234 / 17, 0.001));
    expect(viewModel.notificationCount, 8);
  });

  test('« Mes cours récents » affiche les 3 premiers cours', () async {
    final viewModel = createViewModel();

    await viewModel.load();

    expect(viewModel.recentCourses.length, 3);
    expect(viewModel.recentCourses.first.code, 'MOB301');
  });

  test('API en panne : le tableau de bord reste affiché, notifications « — »', () async {
    final viewModel = createViewModel(apiFails: true);

    await viewModel.load();

    expect(viewModel.status, ViewStatus.success);
    expect(viewModel.courseCount, 6); // Données locales toujours là
    expect(viewModel.notificationCount, isNull);
  });
}
