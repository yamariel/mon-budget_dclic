import 'package:flutter/material.dart';
import 'package:mon_budget/services/google_auth_service.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../core/theme.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_text_field.dart';
import '../../widgets/square_title.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();

  final password = TextEditingController();
  bool _obscurePassword = true;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
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
                Image.asset("assets/logo.png", height: 120, width: 120),
                const SizedBox(height: 16),
                const Text(
                  "Bon retour",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "L'application qui vous aide à gérer vos budgets",
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                MyTextField(
                  controller: email,
                  obscureText: false,
                  hintText: 'Email',
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      auth.errorMessage!,
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
                const SizedBox(height: 32),
                auth.isLoading
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : MyButton(
                        text: "Se connecter",
                        onTap: () => context.read<AuthController>().signIn(
                          email.text,
                          password.text,
                        ),
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
                    SquareTitle(pahtImage: "assets/google.png", onTap: () => GoogleAuthService().signInWithGoogle(),),
                    SizedBox(width: 16),
                    SquareTitle(pahtImage: "assets/apple.png", onTap: () {  },),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Pas de compte ?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      ),
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
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
