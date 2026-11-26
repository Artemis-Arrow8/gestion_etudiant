// =====================================================================
// Écran principal — Navigation entre les rubriques
// =====================================================================

import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../viewmodels/session_viewmodel.dart';
import 'courses_screen.dart';
import 'dashboard_screen.dart';
import 'grades_screen.dart';
import 'profile_screen.dart';

/// Numéros des onglets (utilisés par le tableau de bord pour y accéder).
class HomeTab {
  HomeTab._();
  static const int dashboard = 0;
  static const int courses = 1;
  static const int grades = 2;
  static const int profile = 3;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = HomeTab.dashboard;

  // ViewModel partagé par le tableau de bord et le profil
  late final SessionViewModel _session =
      SessionViewModel(widget.authRepository);

  // Les pages sont créées une seule fois (gardées par l'IndexedStack)
  late final List<Widget> _pages = [
    DashboardScreen(session: _session, onOpenTab: _selectTab),
    // « Voir les notes » sur un cours ouvre l'onglet Notes
    CoursesScreen(onShowGrades: () => _selectTab(HomeTab.grades)),
    const GradesScreen(),
    ProfileScreen(session: _session),
  ];

  // Description des onglets : icône, icône sélectionnée, libellé
  static const List<({IconData icon, IconData selectedIcon, String label})> _tabs = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Accueil'),
    (icon: Icons.book_outlined, selectedIcon: Icons.book, label: 'Cours'),
    (icon: Icons.assessment_outlined, selectedIcon: Icons.assessment, label: 'Notes'),
    (icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profil'),
  ];

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder donne la largeur disponible pour choisir la mise en page
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= AppConstants.wideLayoutBreakpoint;
        final content = IndexedStack(index: _currentIndex, children: _pages);

        if (isWide) {
          // --- Grand écran : menu latéral à gauche ---
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _selectTab,
                    labelType: NavigationRailLabelType.all,
                    backgroundColor: AppColors.surface,
                    indicatorColor: AppColors.primaryLight.withValues(alpha: 0.5),
                    destinations: [
                      for (final tab in _tabs)
                        NavigationRailDestination(
                          icon: Icon(tab.icon, color: AppColors.textMain),
                          selectedIcon: Icon(tab.selectedIcon, color: AppColors.textMain),
                          label: Text(tab.label),
                        ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            ),
          );
        }

        // --- Téléphone : barre de navigation en bas ---
        return Scaffold(
          body: content,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _selectTab,
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primaryLight.withValues(alpha: 0.5),
            destinations: [
              for (final tab in _tabs)
                NavigationDestination(
                  icon: Icon(tab.icon, color: AppColors.textMain),
                  selectedIcon: Icon(tab.selectedIcon, color: AppColors.textMain),
                  label: tab.label,
                ),
            ],
          ),
        );
      },
    );
  }
}
