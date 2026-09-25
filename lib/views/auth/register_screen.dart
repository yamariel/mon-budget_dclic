import 'package:flutter/material.dart';
import 'package:mon_budget/services/google_auth_service.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_text_field.dart';
import '../../widgets/square_title.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;
  String? _localError;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset("assets/logo.png", height: 120, width: 120),
                const SizedBox(height: 16),
                const Text(
                  "Bienvenue sur Budgeto",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "L'application qui vous aide à gérer vos budgets",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                MyTextField(
                  controller: email,
                  obscureText: false,
                  hintText: 'Email',
                ),
                if (auth.errorMessage != null || _localError != null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      _localError ?? auth.errorMessage!,
                      style: const TextStyle(color: AppColors.expenseRed),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    MyTextField(
                      controller: password,
                      obscureText: _obscurePassword,
                      hintText: 'Mot de passe',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    MyTextField(
                      controller: passwordConfirm,
                      obscureText: _obscurePasswordConfirm,
                      hintText: 'Confirmez le mot de passe',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: IconButton(
                        icon: Icon(
                          _obscurePasswordConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePasswordConfirm = !_obscurePasswordConfirm;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                auth.isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : MyButton(
                        text: "S'inscrire",
                        onTap: () async {
                          if (password.text != passwordConfirm.text) {
                            setState(() {
                              _localError =
                                  "Les mots de passe ne correspondent pas.";
                            });
                            return;
                          }
                          setState(() => _localError = null);
                          context.read<AuthController>().signUp(
                            email.text,
                            password.text,
                          );
                        },
                      ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(thickness: 1, color: Color(0xFFE2E8F0)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Ou continuez avec",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Color(0xFFE2E8F0)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTitle(pahtImage: "assets/google.png", onTap: () => GoogleAuthService().signInWithGoogle()),
                    SizedBox(width: 16),
                    SquareTitle(pahtImage: "assets/apple.png", onTap: () {}),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Déjà un compte ?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
