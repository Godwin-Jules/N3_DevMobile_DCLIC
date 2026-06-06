import 'package:flutter/material.dart';
import 'controllers/auth_controller.dart';
import 'data/user_repository.dart';
import 'views/auth_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = UserRepository();
    final controller = AuthController(repo: repo);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVC – Auth Sqflite',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3B82F6),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: AuthPage(controller: controller),
    );
  }
}
