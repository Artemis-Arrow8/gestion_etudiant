// =====================================================================
// Écran de Profil 
// =====================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = AuthService.currentStudent;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mon Profil', 
          style: TextStyle(color: AppColors.darkPlum, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkPlum),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar personnalisé Prune & Lilas
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.softLilac, width: 2),
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.orchidPurple,
                  child: Text(
                    student?.name.isNotEmpty == true ? student!.name[0] : 'E', 
                    style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student?.name ?? 'Étudiant', 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkPlum),
            ),
            const SizedBox(height: 4),
            Text(
              student?.major ?? '', 
              style: const TextStyle(color: AppColors.textMuted, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),

            // Conteneur des détails d'identification
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface, 
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.softLilac.withOpacity(0.3), width: 1),
              ),
              child: Column(
                children: [
                  _buildItem(Icons.badge_outlined, 'Matricule', student?.id ?? ''),
                  Divider(height: 1, color: AppColors.softLilac.withOpacity(0.2)),
                  _buildItem(Icons.email_outlined, 'E-mail institutionnel', student?.email ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Bouton de déconnexion stylisé
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  AuthService.logout();
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginScreen()), 
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.orchidPurple, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout, color: AppColors.orchidPurple),
                label: const Text(
                  'Se déconnecter', 
                  style: TextStyle(color: AppColors.orchidPurple, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.softLilac.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.darkPlum, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                const SizedBox(height: 2),
                Text(
                  value, 
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.darkPlum),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}