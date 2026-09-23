import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../views/auth/login_screen.dart';
import '../controllers/transaction_controller.dart';
import '../views/home_screen.dart';
import 'core/theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        title: "Budgeto",
        home: _RootScreen(),
      ),
    );
  }
}

class _RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.currentUser;
    if (user == null) {
      return LoginScreen();
    }
    return ChangeNotifierProvider(
      create: (_) => TransactionController(user.uid),
      child: HomeScreen(),
    );
  }
}
