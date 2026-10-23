// =====================================================================
// Modèle Notification — Représente une notification ou une annonce 
// =====================================================================

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false, // Par défaut, la notification n'est pas encore lue
  });
}