// =====================================================================
// Écran des notes — Moyenne générale et liste des notes
// =====================================================================

import 'package:flutter/material.dart';

import '../models/grade.dart';
import '../repositories/grade_repository.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../viewmodels/grades_viewmodel.dart';
import '../viewmodels/view_status.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/responsive_body.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key, this.repository});

  final GradeRepository? repository;

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  late final GradesViewModel _viewModel =
      GradesViewModel(repository: widget.repository);

  @override
  void initState() {
    super.initState();
    _viewModel.loadGrades();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes notes')),
      body: ResponsiveBody(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) => _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_viewModel.status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const LoadingView(message: 'Chargement des notes...');
      case ViewStatus.error:
        return ErrorView(
          message: _viewModel.errorMessage ?? 'Une erreur est survenue.',
          onRetry: _viewModel.loadGrades,
        );
      case ViewStatus.empty:
        return const EmptyView(message: 'Aucune note publiée pour le moment.');
      case ViewStatus.success:
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAverageCard(),
            const SizedBox(height: 20),
            for (final grade in _viewModel.grades) _GradeCard(grade: grade),
          ],
        );
    }
  }

  /// Carte de synthèse : moyenne générale pondérée.
  Widget _buildAverageCard() {
    final average = _viewModel.weightedAverage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Moyenne générale pondérée',
            style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            average == null ? '—' : '${Formatters.decimal(average)} / 20',
            style: const TextStyle(color: AppColors.textMain, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coefficient de chaque cours = nombre de crédits',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Carte d'une note (badge doré si validée, rouge sinon).
class _GradeCard extends StatelessWidget {
  const _GradeCard({required this.grade});

  final Grade grade;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          grade.courseName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
        ),
        subtitle: Text(
          '${grade.courseCode} · coefficient ${grade.coefficient}',
          style: const TextStyle(color: AppColors.textMuted),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: grade.isValidated ? AppColors.successBackground : AppColors.errorBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${Formatters.decimal(grade.score)} / 20',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: grade.isValidated ? AppColors.successText : AppColors.errorText,
            ),
          ),
        ),
      ),
    );
  }
}
