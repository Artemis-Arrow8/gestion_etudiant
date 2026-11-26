// =====================================================================
// États possibles d'un écran qui charge des données
// =====================================================================

enum ViewStatus {
  /// Rien n'a encore été chargé.
  initial,

  /// Chargement en cours.
  loading,

  /// Données chargées avec succès (au moins un élément).
  success,

  /// Chargement réussi mais la liste est vide.
  empty,

  /// Le chargement a échoué.
  error,
}
