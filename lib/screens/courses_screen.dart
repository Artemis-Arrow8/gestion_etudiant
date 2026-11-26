// =====================================================================
// Écran des cours — Liste et recherche
// =====================================================================
// Chaque cours affiche son code, son intitulé, son enseignant et son
// nombre de crédits, avec une action « Voir les notes » (TP3).
// =====================================================================

import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../utils/app_colors.dart';
import '../viewmodels/courses_viewmodel.dart';
import '../viewmodels/view_status.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/message_banner.dart';
import '../widgets/responsive_body.dart';

class CoursesScreen extends StatefulWidget {
  /// [repository] est facultatif : il permet d'injecter de fausses
  /// données dans les tests.
  /// [onShowGrades] ouvre l'onglet des notes (action « Voir les notes »).
  const CoursesScreen({super.key, this.repository, this.onShowGrades});

  final CourseRepository? repository;
  final VoidCallback? onShowGrades;

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final CoursesViewModel _viewModel =
      CoursesViewModel(repository: widget.repository);

  @override
  void initState() {
    super.initState();
    _viewModel.loadCourses(); // Premier chargement à l'ouverture
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: ResponsiveBody(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => _buildContent(),
        ),
      ),
    );
  }

  /// Choisit l'affichage selon l'état du ViewModel.
  Widget _buildContent() {
    switch (_viewModel.status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const LoadingView(message: 'Chargement des cours...');
      case ViewStatus.error:
        return ErrorView(
          message: _viewModel.errorMessage ?? 'Une erreur est survenue.',
          onRetry: _viewModel.loadCourses,
        );
      case ViewStatus.empty:
        return const EmptyView(message: 'Aucun cours disponible pour le moment.');
      case ViewStatus.success:
        return _buildCourseList();
    }
  }

  Widget _buildCourseList() {
    final courses = _viewModel.courses;

    return Column(
      children: [
        // --- Recherche ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            onChanged: _viewModel.search,
            decoration: const InputDecoration(
              hintText: 'Cours, code ou enseignant',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),

        // --- API injoignable : les cours restent visibles ---
        if (_viewModel.instructorsUnavailable)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const MessageBanner(
                  type: BannerType.warning,
                  message: 'Noms des enseignants indisponibles : vérifiez votre '
                      'connexion internet.',
                ),
                TextButton.icon(
                  onPressed: _viewModel.loadCourses,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
              ],
            ),
          ),

        // --- Résultats ---
        Expanded(
          child: courses.isEmpty
              ? EmptyView(
                  icon: Icons.search_off,
                  message: 'Aucun cours ne correspond à « ${_viewModel.query} ».',
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) => _CourseCard(
                    course: courses[index],
                    onShowGrades: widget.onShowGrades,
                  ),
                ),
        ),
      ],
    );
  }
}

/// Carte d'un cours dans la liste.
class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course, this.onShowGrades});

  final Course course;
  final VoidCallback? onShowGrades;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intitulé : 2 lignes maximum pour éviter tout débordement
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                course.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${course.code} · ${course.credits} crédits',
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            // Enseignant à gauche, action « Voir les notes » à droite
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    course.instructor ?? 'Enseignant non disponible',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
                TextButton(
                  onPressed: onShowGrades,
                  child: const Text('Voir les notes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
