// =====================================================================
// Écran Principal avec Navigation Bar et Tableau de bord 
// =====================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../repositories/course_repository.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';
import 'courses_screen.dart';
import 'profile_screen.dart';
import 'grades_screen.dart';
import 'schedule_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboardContent(),
    CoursesScreen(repository: CourseRepository()),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: AppColors.softLilac.withOpacity(0.5),
        backgroundColor: AppColors.surface,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.darkPlum),
            selectedIcon: Icon(Icons.home, color: AppColors.darkPlum),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined, color: AppColors.darkPlum),
            selectedIcon: Icon(Icons.book, color: AppColors.darkPlum),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.darkPlum),
            selectedIcon: Icon(Icons.person, color: AppColors.darkPlum),
            label: 'Profil',
          ),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tableau de bord', style: TextStyle(color: AppColors.darkPlum, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.orchidPurple),
            tooltip: 'Déconnexion',
            onPressed: () {
              AuthService.logout();
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
            // Carte de bienvenue aux tons Prune & Lilas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkPlum.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.orchidPurple,
                    child: Text(
                      student?.name.isNotEmpty == true ? student!.name[0] : 'E', 
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour, ${student?.name ?? "Étudiant"} !', 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPlum),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Filière : ${student?.major ?? ""}', 
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Espace Pédagogique', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkPlum),
            ),
            const SizedBox(height: 14),
            
            // Grille des cartes fonctionnelles
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildCard(
                  Icons.book_outlined, 
                  'Mes Cours', 
                  AppColors.surface, 
                  AppColors.orchidPurple, 
                  () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => CoursesScreen(repository: CourseRepository()),
                      ),
                    );
                  },
                ),
                _buildCard(
                  Icons.assessment_outlined, 
                  'Mes Notes', 
                  AppColors.surface, 
                  AppColors.darkPlum, 
                  () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const GradesScreen()),
                    );
                  },
                ),
                _buildCard(
                  Icons.schedule_outlined, 
                  'Emploi du temps', 
                  AppColors.surface, 
                  AppColors.softLilac, 
                  () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const ScheduleScreen()),
                    );
                  },
                ),
                _buildCard(
                  Icons.notifications_outlined, 
                  'Notifications', 
                  AppColors.surface, 
                  AppColors.orchidPurple, 
                  () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, Color bgColor, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor, 
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.softLilac.withOpacity(0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const Spacer(),
            Text(
              title, 
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkPlum),
            ),
          ],
        ),
      ),
    );
  }
}