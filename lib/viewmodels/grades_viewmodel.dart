// =====================================================================
// ViewModel — Notes de l'étudiant et moyenne générale
// =====================================================================

import 'package:flutter/foundation.dart';

import '../models/grade.dart';
import '../repositories/grade_repository.dart';
import 'base_viewmodel.dart';
import 'view_status.dart';

class GradesViewModel extends BaseViewModel {
  GradesViewModel({GradeRepository? repository})
      : _repository = repository ?? GradeRepository();

  final GradeRepository _repository;

  ViewStatus _status = ViewStatus.initial;
  String? _errorMessage;
  List<Grade> _grades = [];

  ViewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Grade> get grades => _grades;

  /// Moyenne générale pondérée par les crédits (`null` s'il n'y a aucune
  /// note). Le calcul est fait dans le modèle Grade, pour être partagé
  /// avec le tableau de bord.
  double? get weightedAverage => Grade.weightedAverage(_grades);

  /// Charge (ou recharge) les notes.
  Future<void> loadGrades() async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _grades = await _repository.getGrades();
      _status = _grades.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } catch (e) {
      debugPrint('Erreur de chargement des notes : $e');
      _status = ViewStatus.error;
      _errorMessage = 'Impossible de charger les notes. Veuillez réessayer.';
    }
    notifyListeners();
  }
}
