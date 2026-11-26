// =====================================================================
// Écran de connexion 
// =====================================================================

import 'package:flutter/material.dart';

import '../repositories/auth_repository.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/message_banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Le ViewModel est créé une seule fois, à la création de l'écran
  late final LoginViewModel _viewModel =
      LoginViewModel(widget.authRepository);

  // Afficher / masquer le mot de passe : simple état visuel de l'écran
  bool _obscurePassword = true;

  @override
  void dispose() {
    // On libère les ressources quand l'écran disparaît
    _emailController.dispose();
    _passwordController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  /// Appelé par le bouton "Se connecter" (ou la touche Entrée).
  Future<void> _submit() async {
    FocusScope.of(context).unfocus(); // Ferme le clavier

    // 1. Validation des champs : on s'arrête si un champ est invalide
    if (!_formKey.currentState!.validate()) return;

    // 2. Demande de connexion au ViewModel. En cas de succès, l'AuthGate
    //    affichera l'accueil : aucune navigation à faire ici.
    await _viewModel.login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            // Largeur limitée pour rester agréable sur tablette / web
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              // L'écran se redessine quand l'état du ViewModel change
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) => _buildForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- En-tête : logo + titre ---
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_outlined, size: 50, color: AppColors.textMain),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Connexion Étudiante',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textMain),
          ),
          const SizedBox(height: 8),
          const Text(
            'Accédez à votre espace pédagogique',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          const SizedBox(height: 32),

          // --- Message d'échec de connexion (fourni par le ViewModel) ---
          if (_viewModel.errorMessage != null) ...[
            MessageBanner(message: _viewModel.errorMessage!, type: BannerType.error),
            const SizedBox(height: 16),
          ],

          // --- Champ email ---
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            style: const TextStyle(color: AppColors.textMain),
            decoration: const InputDecoration(
              labelText: 'Email institutionnel',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: Validators.email,
          ),
          const SizedBox(height: 16),

          // --- Champ mot de passe ---
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            onFieldSubmitted: (_) => _submit(),
            style: const TextStyle(color: AppColors.textMain),
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                tooltip: _obscurePassword ? 'Afficher le mot de passe' : 'Masquer le mot de passe',
                icon: Icon(_obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: Validators.password,
          ),
          const SizedBox(height: 8),

          // --- Case "Se souvenir de moi" (persistance de la session) ---
          CheckboxListTile(
            value: _viewModel.rememberMe,
            onChanged: _viewModel.isLoading
                ? null
                : (value) => _viewModel.setRememberMe(value ?? false),
            title: const Text('Se souvenir de moi', style: TextStyle(color: AppColors.textMain)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: 16),

          // --- Bouton de connexion (désactivé pendant le chargement) ---
          ElevatedButton(
            onPressed: _viewModel.isLoading ? null : _submit,
            child: _viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text('Se connecter'),
          ),
          const SizedBox(height: 24),

          // --- Transparence : on signale que l'authentification est simulée ---
          const MessageBanner(
            message: 'Connexion simulée avec un compte de démonstration '
                '(identifiants indiqués dans le README).',
          ),
        ],
      ),
    );
  }
}
