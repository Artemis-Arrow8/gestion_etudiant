// =====================================================================
// Écran du profil (onglet "Profil")
// =====================================================================

import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../viewmodels/session_viewmodel.dart';
import '../widgets/info_tile.dart';
import '../widgets/logout_dialog.dart';
import '../widgets/responsive_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.session});

  final SessionViewModel session;

  @override
  Widget build(BuildContext context) {
    final student = session.student;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ResponsiveBody(
          maxWidth: 560,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // --- Avatar avec l'initiale ---
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryLight, width: 2),
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    student?.initial ?? 'E',
                    style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                student?.name ?? 'Étudiant',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
              ),
              const SizedBox(height: 4),
              Text(
                student == null ? '' : '${student.major} · ${student.level}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),

              // --- Informations d'identification ---
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    InfoTile(icon: Icons.badge_outlined, label: 'Matricule', value: student?.id ?? ''),
                    const Divider(height: 1, color: AppColors.border),
                    InfoTile(icon: Icons.email_outlined, label: 'Email institutionnel', value: student?.email ?? ''),
                    const Divider(height: 1, color: AppColors.border),
                    InfoTile(icon: Icons.school_outlined, label: 'Filière', value: student?.major ?? ''),
                    const Divider(height: 1, color: AppColors.border),
                    InfoTile(icon: Icons.stairs_outlined, label: 'Niveau', value: student?.level ?? ''),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- Déconnexion ---
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => confirmLogout(context, session),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.logout, color: AppColors.primary),
                  label: const Text(
                    'Se déconnecter',
                    style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
