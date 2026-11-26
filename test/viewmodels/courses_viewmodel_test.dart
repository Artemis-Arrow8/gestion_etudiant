// =====================================================================
// Tests unitaires — CoursesViewModel (états et recherche)
// =====================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_etudiant/models/course.dart';
import 'package:gestion_etudiant/repositories/course_repository.dart';
import 'package:gestion_etudiant/viewmodels/courses_viewmodel.dart';
import 'package:gestion_etudiant/viewmodels/view_status.dart';

/// Faux repository : renvoie la liste fournie, ou lève une erreur.
class FakeCourseRepository implements CourseRepository {
  FakeCourseRepository({this.courses = const [], this.shouldFail = false});

  final List<Course> courses;
  final bool shouldFail;

  @override
  Future<List<Course>> getCatalog() async => courses;

  @override
  Future<List<Course>> getCourses() async {
    if (shouldFail) throw Exception('Erreur technique simulée');
    return courses;
  }

  @override
  void dispose() {} // Pas de client HTTP à fermer
}

// Quelques cours de test (avec leur enseignant)
const _courses = [
  Course(code: 'MOB301', title: 'Développement mobile avancé', credits: 4, instructorId: 1, instructor: 'Leanne Graham'),
  Course(code: 'GEN302', title: 'Génie logiciel et UML', credits: 3, instructorId: 2, instructor: 'Ervin Howell'),
  Course(code: 'RES304', title: 'Réseaux informatiques', credits: 3, instructorId: 4, instructor: 'Patricia Lebsack'),
];

void main() {
  test('Chargement réussi : état "success" et tous les cours', () async {
    final viewModel = CoursesViewModel(repository: FakeCourseRepository(courses: _courses));

    await viewModel.loadCourses();

    expect(viewModel.status, ViewStatus.success);
    expect(viewModel.courses.length, 3);
    expect(viewModel.instructorsUnavailable, isFalse);
  });

  test('Liste vide : état "empty"', () async {
    final viewModel = CoursesViewModel(repository: FakeCourseRepository());

    await viewModel.loadCourses();

    expect(viewModel.status, ViewStatus.empty);
  });

  test("Erreur : état \"error\" et message sans détail technique", () async {
    final viewModel = CoursesViewModel(repository: FakeCourseRepository(shouldFail: true));

    await viewModel.loadCourses();

    expect(viewModel.status, ViewStatus.error);
    expect(viewModel.errorMessage, isNotNull);
    // Le détail technique de l'exception n'est pas montré à l'utilisateur
    expect(viewModel.errorMessage, isNot(contains('Exception')));
  });

  test('Cours sans enseignant (API injoignable) : bandeau "réessayer" prévu', () async {
    const withoutTeachers = [
      Course(code: 'MOB301', title: 'Développement mobile avancé', credits: 4, instructorId: 1),
      Course(code: 'GEN302', title: 'Génie logiciel et UML', credits: 3, instructorId: 2),
    ];
    final viewModel = CoursesViewModel(repository: FakeCourseRepository(courses: withoutTeachers));

    await viewModel.loadCourses();

    expect(viewModel.status, ViewStatus.success); // Les cours restent affichés
    expect(viewModel.instructorsUnavailable, isTrue);
  });

  test('Recherche par intitulé, code ou enseignant (majuscules ignorées)', () async {
    final viewModel = CoursesViewModel(repository: FakeCourseRepository(courses: _courses));
    await viewModel.loadCourses();

    viewModel.search('GÉNIE');
    expect(viewModel.courses.single.code, 'GEN302');

    viewModel.search('res304');
    expect(viewModel.courses.single.title, 'Réseaux informatiques');

    viewModel.search('leanne');
    expect(viewModel.courses.single.code, 'MOB301');

    viewModel.search(''); // Recherche effacée : tous les cours reviennent
    expect(viewModel.courses.length, 3);
  });
}
