// =====================================================================
// Écran des Cours — Consultation de la liste des modules
// =====================================================================

import 'package:flutter/material.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';
import '../utils/app_colors.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  // Instance du repository pour charger les cours
  final CourseRepository _courseRepository = CourseRepository();

  // Liste locale des cours affichés à l'écran
  List<Course> _courses = [];

  // État d'affichage du chargement (loader)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Chargement automatique des données dès l'initialisation de l'écran
    _loadCourses();
  }

  /// Méthode asynchrone pour récupérer les cours depuis le repository
  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    final fetchedCourses = await _courseRepository.getCourses();
    setState(() {
      _courses = fetchedCourses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Cours', style: TextStyle(color: AppColors.textMain)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      // 1. Affichage de l'indicateur de chargement si les données arrivent
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.textMain),
            )
          // 2. Gestion de l'affichage quand la liste est vide
          : _courses.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun cours disponible.',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              // 3. Construction dynamique de la liste avec ListView.builder
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    final course = _courses[index];
                    return Card(
                      color: AppColors.surface,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        // Icône du cours dans une bulle pastel
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primaryLavender.withOpacity(0.6),
                          child: const Icon(Icons.book, color: AppColors.textMain),
                        ),
                        // Intitulé du cours
                        title: Text(
                          course.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain),
                        ),
                        // Détails (Code et Enseignant)
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Code : ${course.code} • ${course.instructor}',
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 13),
                          ),
                        ),
                        // Bouton d'action "Détails"
                        trailing: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Consultation du module : ${course.title}'),
                                backgroundColor: AppColors.textMain,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryPink.withOpacity(0.4),
                            foregroundColor: AppColors.textMain,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Détails'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}