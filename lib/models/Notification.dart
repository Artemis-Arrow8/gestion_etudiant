// =====================================================================
// Ce fichier représente le modèle d'une notification de l'administration.
// =====================================================================

class NotificationModel {
  final String title;     // Titre de l'annonce
  final String message;   // Contenu détaillé de la notification
  final DateTime date;    // Date et heure de publication

  const NotificationModel({
    required this.title,
    required this.message,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'date': date.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }
}