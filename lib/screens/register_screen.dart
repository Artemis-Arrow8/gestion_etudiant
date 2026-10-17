// =====================================================================
//  Formulaire d'inscription pour créer un nouveau profil étudiant.
// =====================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Contrôleurs pour récupérer les informations du formulaire d'inscription
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  
  String _errorMessage = '';

  @override
  void dispose() {
    // Libération des ressources des contrôleurs
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  // Fonction appelée lors de la soumission de l'inscription
  void _handleRegister() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String major = _majorController.text.trim();

    // Vérifie si tous les champs sont remplis
    if (name.isEmpty || email.isEmpty || password.isEmpty || major.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    // Enregistre l'étudiant via le service d'authentification
    bool success = AuthService.register(
      name: name,
      email: email,
      password: password,
      major: major,
    );

    if (success && mounted) {
      // Si l'inscription réussit, on redirige vers le tableau de bord et efface l'historique
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = 'Cet email est déjà associé à un autre compte.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Inscription Étudiant'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Créer votre compte',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Remplissez vos informations pour accéder à l\'application.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Affichage des erreurs éventuelles
            if (_errorMessage.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red.shade700)),
              ),
              const SizedBox(height: 16),
            ],

            // Champ : Nom complet
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom complet',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),

            // Champ : Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Adresse email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Champ : Filière
            TextField(
              controller: _majorController,
              decoration: InputDecoration(
                labelText: 'Filière (ex: Génie Logiciel)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Champ : Mot de passe
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 24),

            // Bouton de validation
            ElevatedButton(
              onPressed: _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("S'inscrire", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}