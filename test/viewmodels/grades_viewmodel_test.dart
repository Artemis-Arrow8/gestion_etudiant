// =====================================================================
// Tests unitaires — GradesViewModel (moyenne et états)
// =====================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_etudiant/models/grade.dart';
import 'package:gestion_etudiant/repositories/grade_repository.dart';
import 'package:gestion_etudiant/viewmodels/grades_viewmodel.dart';
import 'package:gestion_etudiant/viewmodels/view_status.dart';

/// Faux repository de notes.
class FakeGradeRepository implements GradeRepository {
  FakeGradeRepository(this.grades);

  final List<Grade> grades;

  @override
  Future<List<Grade>> getGrades() async => grades;
}

void main() {
  test('Moyenne pondérée par les coefficients (crédits)', () async {
    final viewModel = GradesViewModel(
      repository: FakeGradeRepository(const [
        Grade(courseCode: 'MOB301', courseName: 'Développement mobile', score: 16, coefficient: 4),
        Grade(courseCode: 'GEN302', courseName: 'Génie logiciel', score: 10, coefficient: 2),
        Grade(courseCode: 'RES304', courseName: 'Réseaux', score: 7, coefficient: 2),
      ]),
    );

    await viewModel.loadGrades();

    // (16 x 4 + 10 x 2 + 7 x 2) / (4 + 2 + 2) = 98 / 8 = 12,25
    expect(viewModel.status, ViewStatus.success);
    expect(viewModel.weightedAverage, closeTo(12.25, 0.001));
  });

  test('Aucune note : état "empty" et pas de moyenne', () async {
    final viewModel = GradesViewModel(repository: FakeGradeRepository([]));

    await viewModel.loadGrades();

    expect(viewModel.status, ViewStatus.empty);
    expect(viewModel.weightedAverage, isNull);
  });

  test('Note validée à partir de 10/20', () {
    const passed = Grade(courseCode: 'A', courseName: 'A', score: 10, coefficient: 1);
    const failed = Grade(courseCode: 'B', courseName: 'B', score: 9.5, coefficient: 1);

    expect(passed.isValidated, isTrue);
    expect(failed.isValidated, isFalse);
  });
}
