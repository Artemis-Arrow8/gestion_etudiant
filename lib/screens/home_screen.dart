// =====================================================================
// FICHIER : lib/screens/home_screen.dart
// RÔLE : Tableau de bord principal de l'application.
// =====================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupère l'étudiant connecté depuis le service d'authentification
    final student = AuthService.currentStudent;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Fond gris très clair, épuré
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Bouton de déconnexion dans la barre supérieure
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Se déconnecter',
            onPressed: () {
              AuthService.logout();
              // Retourne à l'écran de connexion et supprime l'historique des pages
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte de profil utilisateur (Style pastel / moderne)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                children: [
                  // Avatar affichant la première lettre du nom de l'étudiant
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal,
                    child: Text(
                      student?.name.isNotEmpty == true ? student!.name[0].toUpperCase() : 'E',
                      style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Détails du profil
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student?.name ?? 'Étudiant',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Filière : ${student?.major ?? "Non définie"}',
                          style: TextStyle(color: Colors.teal.shade800, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          student?.email ?? '',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Titre de la section
            const Text(
              'Espace Pédagogique',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Grille des options interactives
            GridView.count(
              crossAxisCount: 2, // 2 cartes par ligne
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildDashboardCard(
                  icon: Icons.book_outlined,
                  title: 'Mes Cours',
                  color: Colors.blue.shade50,
                  iconColor: Colors.blue,
                  onTap: () => _showInfoDialog(context, 'Mes Cours', 'Modules : Développement Mobile, Intelligence Artificielle, Base de Données.'),
                ),
                _buildDashboardCard(
                  icon: Icons.assessment_outlined,
                  title: 'Mes Notes',
                  color: Colors.orange.shade50,
                  iconColor: Colors.orange,
                  onTap: () => _showInfoDialog(context, 'Mes Notes', 'Consultez vos notes de travaux pratiques et examens semestriels.'),
                ),
                _buildDashboardCard(
                  icon: Icons.schedule_outlined,
                  title: 'Emploi du temps',
                  color: Colors.purple.shade50,
                  iconColor: Colors.purple,
                  onTap: () => _showInfoDialog(context, 'Emploi du temps', 'Planning hebdomadaire des cours et des séances de TP en salle info.'),
                ),
                _buildDashboardCard(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  color: Colors.green.shade50,
                  iconColor: Colors.green,
                  onTap: () => _showInfoDialog(context, 'Notifications', 'Aucune nouvelle annonce de l\'administration pour le moment.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour concevoir les cartes du tableau de bord
  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // Boîte de dialogue pour afficher les détails des modules lorsqu'on clique dessus
  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}