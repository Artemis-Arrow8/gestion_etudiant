// =====================================================================
// Écran Principal avec Navigation Bar et Tableau de bord
// =====================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'courses_screen.dart';
import 'profile_screen.dart';
import 'grades_screen.dart';
import 'schedule_screen.dart';       // Import de l'écran Emploi du temps
import 'notifications_screen.dart'; // Import de l'écran Notifications

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Liste des écrans accessibles via la barre de navigation principale
  final List<Widget> _screens = [
    const HomeDashboardContent(),
    const CoursesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.book_outlined), selectedIcon: Icon(Icons.book), label: 'Cours'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeDashboardContent extends StatelessWidget {
  const HomeDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final student = AuthService.currentStudent;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carte de bienvenue de l'étudiant connecté
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.teal,
                    child: Text(student?.name[0] ?? 'E', style: const TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour, ${student?.name ?? "Étudiant"} !', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Filière : ${student?.major ?? ""}', style: TextStyle(color: Colors.teal.shade800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Espace Pédagogique', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Grille des raccourcis pédagogiques
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                // 1. Bouton Mes Cours
                _buildCard(Icons.book_outlined, 'Mes Cours', Colors.blue.shade50, Colors.blue, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CoursesScreen()));
                }),
                // 2. Bouton Mes Notes
                _buildCard(Icons.assessment_outlined, 'Mes Notes', Colors.orange.shade50, Colors.orange, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GradesScreen()));
                }),
                // 3. Bouton Emploi du temps (Corrigé avec la navigation)
                _buildCard(Icons.schedule_outlined, 'Emploi du temps', Colors.purple.shade50, Colors.purple, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleScreen()));
                }),
                // 4. Bouton Notifications (Corrigé avec la navigation)
                _buildCard(Icons.notifications_outlined, 'Notifications', Colors.green.shade50, Colors.green, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget utilitaire pour construire les cartes de la grille
  Widget _buildCard(IconData icon, String title, Color color, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: iconColor),
            const Spacer(),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}