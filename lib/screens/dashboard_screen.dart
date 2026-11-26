// =====================================================================
// Tableau de bord (onglet "Accueil")
// =====================================================================


import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import '../viewmodels/session_viewmodel.dart';
import '../viewmodels/view_status.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/error_view.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/responsive_body.dart';
import '../widgets/stat_tile.dart';
import 'attendance_screen.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.session,
    required this.onOpenTab,
  });

  final SessionViewModel session;

  /// Permet d'ouvrir un autre onglet (Cours, Notes...) depuis une carte.
  final ValueChanged<int> onOpenTab;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardViewModel _viewModel = DashboardViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.load(); // Chargement des indicateurs à l'ouverture
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  /// Ouvre un écran par-dessus l'accueil (bouton "retour" disponible).
  void _open(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primary),
            tooltip: 'Déconnexion',
            onPressed: () => confirmLogout(context, widget.session),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ResponsiveBody(
          maxWidth: 960,
          child: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 24),
                ..._buildDataSections(),
                const SizedBox(height: 24),
                _buildSectionTitle('Espace pédagogique'),
                const SizedBox(height: 12),
                _buildShortcutGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // Carte de bienvenue
  // -------------------------------------------------------------------
  Widget _buildWelcomeCard() {
    final student = widget.session.student;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        // Fine bordure plutôt qu'une ombre : style épuré
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            child: Text(
              student?.initial ?? 'E',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, ${student?.firstName ?? 'Étudiant'} !',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                const SizedBox(height: 4),
                Text(
                  student == null ? '' : '${student.major} · ${student.level}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // Indicateurs et cours récents (selon l'état du chargement)
  // -------------------------------------------------------------------
  List<Widget> _buildDataSections() {
    switch (_viewModel.status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
        ];
      case ViewStatus.error:
      case ViewStatus.empty:
        return [
          ErrorView(
            message: 'Impossible de charger vos indicateurs. Veuillez réessayer.',
            onRetry: _viewModel.load,
          ),
        ];
      case ViewStatus.success:
        return [
          _buildSectionTitle('Mes indicateurs'),
          const SizedBox(height: 12),
          _buildIndicators(),
          const SizedBox(height: 24),
          _buildRecentCoursesHeader(),
          const SizedBox(height: 8),
          for (final course in _viewModel.recentCourses)
            Card(
              child: ListTile(
                leading: const Icon(Icons.book_outlined, color: AppColors.accent),
                title: Text(
                  course.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMain),
                ),
                subtitle: Text(
                  '${course.code} · ${course.credits} crédits',
                  style: const TextStyle(color: AppColors.textMuted),
                ),
                onTap: () => widget.onOpenTab(HomeTab.courses),
              ),
            ),
        ];
    }
  }

  /// Trois indicateurs. Sur un écran étroit, ils passent les uns sous les
  /// autres au lieu d'être serrés sur une seule ligne.
  Widget _buildIndicators() {
    final average = _viewModel.average;
    final notifications = _viewModel.notificationCount;

    final String notificationText;
    if (_viewModel.notificationsLoading) {
      notificationText = '…';
    } else {
      notificationText = notifications == null ? '—' : '$notifications';
    }

    final tiles = [
      StatTile(
        icon: Icons.book_outlined,
        value: '${_viewModel.courseCount}',
        label: 'Cours suivis',
        onTap: () => widget.onOpenTab(HomeTab.courses),
      ),
      StatTile(
        icon: Icons.assessment_outlined,
        value: average == null ? '—' : Formatters.decimal(average),
        label: 'Moyenne',
        onTap: () => widget.onOpenTab(HomeTab.grades),
      ),
      StatTile(
        icon: Icons.notifications_outlined,
        value: notificationText,
        label: 'Notifications',
        onTap: () => _open(const NotificationsScreen()),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        // 3 par ligne si la place le permet, sinon 1 par ligne
        final int perRow = constraints.maxWidth >= 330 ? 3 : 1;
        final double width = (constraints.maxWidth - spacing * (perRow - 1)) / perRow;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [for (final tile in tiles) SizedBox(width: width, child: tile)],
        );
      },
    );
  }

  Widget _buildRecentCoursesHeader() {
    return Row(
      children: [
        Expanded(child: _buildSectionTitle('Mes cours récents')),
        TextButton(
          onPressed: () => widget.onOpenTab(HomeTab.courses),
          child: const Text('Voir tout'),
        ),
      ],
    );
  }

  // -------------------------------------------------------------------
  // Raccourcis vers les rubriques
  // -------------------------------------------------------------------
  Widget _buildShortcutGrid() {
    // maxCrossAxisExtent : chaque carte fait au plus 220 px de large,
    // le nombre de colonnes est donc calculé selon l'écran.
    return GridView.extent(
      maxCrossAxisExtent: 220,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      // Hauteur suffisante pour un titre sur deux lignes
      childAspectRatio: 1.1,
      children: [
        DashboardCard(
          icon: Icons.book_outlined,
          title: 'Mes cours',
          color: AppColors.accent,
          onTap: () => widget.onOpenTab(HomeTab.courses),
        ),
        DashboardCard(
          icon: Icons.assessment_outlined,
          title: 'Mes notes',
          color: AppColors.textMain,
          onTap: () => widget.onOpenTab(HomeTab.grades),
        ),
        DashboardCard(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          color: AppColors.accent,
          onTap: () => _open(const NotificationsScreen()),
        ),
        DashboardCard(
          icon: Icons.location_on_outlined,
          title: 'Présence campus',
          color: AppColors.textMain,
          onTap: () => _open(const AttendanceScreen()),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
    );
  }
}
