// =====================================================================
// Écran des Notes 
// =====================================================================

import 'package:flutter/material.dart';
import '../models/Grade.dart';
import '../utils/app_colors.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  final List<Grade> grades = const [
    Grade(courseName: 'Développement mobile avancé', score: 16.5, coefficient: 3.0),
    Grade(courseName: 'Génie logiciel et UML', score: 14.0, coefficient: 2.0),
    Grade(courseName: 'Bases de données relationnelles', score: 15.0, coefficient: 3.0),
  ];

  double _calculateGPA() {
    if (grades.isEmpty) return 0.0;
    double points = 0, coefs = 0;
    for (var g in grades) {
      points += g.score * g.coefficient;
      coefs += g.coefficient;
    }
    return coefs > 0 ? points / coefs : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final gpa = _calculateGPA();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Notes', style: TextStyle(color: AppColors.textMain)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accentSage.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Moyenne Générale Pondérée',
                    style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${gpa.toStringAsFixed(2)} / 20',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Détails des Évaluations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return Card(
                  color: AppColors.surface,
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(grade.courseName, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain)),
                    subtitle: Text('Coefficient : ${grade.coefficient}', style: const TextStyle(color: AppColors.textMuted)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${grade.score} / 20',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}