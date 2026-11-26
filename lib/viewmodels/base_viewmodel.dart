// =====================================================================
// Classe de base de tous les ViewModels
// =====================================================================

import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isDisposed = false;

  /// Vrai quand l'écran associé a été fermé.
  bool get isDisposed => _isDisposed;

  @override
  void notifyListeners() {
    // On ne prévient l'écran que s'il existe encore
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
