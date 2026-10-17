// =====================================================================
// L'Écran de connexion de l'application.
// =====================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Contrôleurs pour récupérer les textes saisis par l'utilisateur
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Variable pour afficher les messages d'erreur en cas de mauvais identifiants
  String _errorMessage = '';

  @override
  void dispose() {
    // Libère la mémoire allouée aux contrôleurs lorsque l'écran est détruit
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fonction appelée lors du clic sur "Se connecter"
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validation rapide des champs vides
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs.';
      });
      return;
    }

    // Appel du service de connexion
    bool success = AuthService.login(email, password);

    if (success && mounted) {
      // Si la connexion réussit, on va vers le tableau de bord
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Si elle échoue, on affiche l'erreur
      setState(() {
        _errorMessage = 'Email ou mot de passe incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo / Icône de l'application
              const Icon(Icons.school_outlined, size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              const Text(
                'Gestion Étudiants',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Connectez-vous pour accéder à votre espace',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Boîte d'affichage des erreurs conditionnelle
              if (_errorMessage.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Champ Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email institutionnel',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Champ Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true, // Masque les caractères du mot de passe
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton de validation de la connexion
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Se connecter', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),

              // Lien vers l'écran d'inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Pas encore de compte ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "S'inscrire",
                      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}