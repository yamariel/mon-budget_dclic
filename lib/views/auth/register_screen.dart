import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
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
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset("assets/logo.png", height: 140, width: 140),
                const SizedBox(height: 10),
                const Text(
                  "Bienvenu sur Budgeto",
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "L'application qui vous aide à géré vos budget",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 40),
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
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    MyTextField(
                      controller: password,
                      obscureText: _obscurePassword,
                      hintText: 'Mot de passe',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[700],
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
                const SizedBox(height: 30),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    MyTextField(
                      controller: passwordConfirm,
                      obscureText: true,
                      hintText: 'Confirmez le mot de passe',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        icon: Icon(
                          _obscurePasswordConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[700],
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
                const SizedBox(height: 40),
                auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : MyButton(
                        text: "S'inscrire",
                        onTap: () {
                          if (password.text != passwordConfirm.text) {
                            setState(() {
                              _localError =
                                  "Les mots de passe ne correspondent pas.";
                            });
                            return;
                          }
                          setState(() => _localError = null);
                          context.read<AuthController>().signUp(email.text, password.text);
                        },
                      ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text(
                          "Où continuez avec",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTitle(pahtImage: "assets/google.png"),
                    const SizedBox(width: 10),
                    SquareTitle(pahtImage: "assets/apple.png"),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Déjà un compte ?",
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                          color: Colors.blue,
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
