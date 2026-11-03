// =====================================================================
// Écran de l'Emploi du temps — Gestion des horaires de cours
// =====================================================================

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScheduleItem {
  final String day;
  final String time;
  final String course;
  final String room;

  const ScheduleItem({
    required this.day,
    required this.time,
    required this.course,
    required this.room,
  });
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Liste initiale des horaires de cours
  final List<ScheduleItem> _schedule = const [
    ScheduleItem(day: 'Lundi', time: '08:00 - 12:00', course: 'Développement mobile avancé', room: 'Labo 3'),
    ScheduleItem(day: 'Mardi', time: '14:00 - 17:00', course: 'Génie logiciel et UML', room: 'Amphi B'),
    ScheduleItem(day: 'Mercredi', time: '09:00 - 12:00', course: 'Bases de données relationnelles', room: 'Labo 1'),
    ScheduleItem(day: 'Jeudi', time: '15:00 - 18:00', course: 'Réseaux informatiques', room: 'Salle 12'),
  ];

  /// Méthode simulant le rafraîchissement des données (ex: appel réseau futur)
  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulation d'un délai réseau
    setState(() {
      // Rechargement ou tri optionnel des données
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emploi du temps', style: TextStyle(color: AppColors.textMain)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      // Intégration du RefreshIndicator pour permettre le glisser-vers-le-bas
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.textMain,
        backgroundColor: AppColors.surface,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _schedule.length,
          itemBuilder: (context, index) {
            final item = _schedule[index];
            return Card(
              color: AppColors.surface,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.softLilac.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item.day,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
                  ),
                ),
                title: Text(
                  item.course,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textMain),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    ' ${item.time}  •   ${item.room}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}