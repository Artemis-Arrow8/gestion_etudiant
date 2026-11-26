// =====================================================================
// Modèle NotificationModel — Une annonce ou notification
// =====================================================================

class NotificationModel {
  final int id;
  final String title;
  final String message;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
  });

  /// Crée une notification à partir de la réponse JSON de l'API.
  /// Dans l'API, le texte de l'annonce s'appelle "body".
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Annonce',
      message: json['body'] as String? ?? '',
    );
  }
}
