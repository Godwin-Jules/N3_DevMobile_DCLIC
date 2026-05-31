import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'auth_page.dart';

class HomePage extends StatelessWidget {
  final AuthController controller;
  const HomePage({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    final username = controller.currentUser?.username ?? "Utilisateur";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accueil"),
        actions: [
          TextButton.icon(
            onPressed: () {
              controller.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => AuthPage(controller: controller),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, size: 42),
                const SizedBox(height: 10),
                Text(
                  "Bienvenue $username ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Connexion réussie (MVC + sqflite).",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
