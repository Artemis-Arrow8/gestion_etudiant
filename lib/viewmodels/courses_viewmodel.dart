// =====================================================================
// ViewModel — Liste des cours (avec recherche)
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import 'base_viewmodel.dart';
import 'view_status.dart';

class CoursesViewModel extends BaseViewModel {
  CoursesViewModel({CourseRepository? repository})
      : _repository = repository ?? CourseRepository();

  final CourseRepository _repository;

  ViewStatus _status = ViewStatus.initial;
  String? _errorMessage;
  List<Course> _allCourses = []; // Tous les cours chargés
  String _query = ''; // Texte de recherche actuel

  ViewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String get query => _query;

  /// Vrai si les cours sont affichés sans leurs enseignants
  /// (l'API n'a pas répondu) : l'écran propose alors de réessayer.
  bool get instructorsUnavailable =>
      _allCourses.isNotEmpty && _allCourses.every((course) => course.instructor == null);

  /// Cours à afficher : tous, ou seulement ceux dont l'intitulé, le code
  /// ou l'enseignant contient le texte recherché.
  List<Course> get courses {
    if (_query.isEmpty) return _allCourses;

    final search = _query.toLowerCase();
    return _allCourses.where((course) {
      return course.title.toLowerCase().contains(search) ||
          course.code.toLowerCase().contains(search) ||
          (course.instructor?.toLowerCase().contains(search) ?? false);
    }).toList();
  }

  /// Charge (ou recharge) la liste des cours.
  Future<void> loadCourses() async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _allCourses = await _repository.getCourses();
      _status = _allCourses.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      // L'utilisateur voit un message simple ; le détail reste en console
      debugPrint('Erreur de chargement des cours : $e');
      _status = ViewStatus.error;
      _errorMessage = 'Impossible de charger les cours. Veuillez réessayer.';
    }
    notifyListeners();
  }

  /// Met à jour le texte de recherche (appelé à chaque frappe).
  void search(String query) {
    _query = query.trim();
    notifyListeners();
  }

  @override
  void dispose() {
    _repository.dispose(); // Ferme le client HTTP
    super.dispose();
  }
}
