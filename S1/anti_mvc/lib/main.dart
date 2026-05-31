import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// Anti-MVC : UI + SQLite + logique métier dans la même classe.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anti MVC Login',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const LoginPageMessy(),
    );
  }
}

class LoginPageMessy extends StatefulWidget {
  const LoginPageMessy({super.key});
  @override
  State<LoginPageMessy> createState() => _LoginPageMessyState();
}

class _LoginPageMessyState extends State<LoginPageMessy> {
  // UI state
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool obscure = true;
  bool registerMode = false;
  String? error;
  // DB state
  Database? db;
  @override
  void initState() {
    super.initState();
    _initDb(); // la page UI initialise la base
  }

  Future<void> _initDb() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'messy_auth.db');
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (d, v) async {
          await d.execute('''
CREATE TABLE users(
id INTEGER PRIMARY KEY AUTOINCREMENT,
username TEXT NOT NULL UNIQUE,
password_hash TEXT NOT NULL
);
''');
        },
      );
    } catch (e) {
      error = "Erreur DB: $e";
    } finally {
      setState(() => loading = false);
    }
  }

  String _hash(String password) {
    // logique de sécurité dans la view
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _submit() async {
    FocusScope.of(context as BuildContext).unfocus();
    final username = userCtrl.text.trim();
    final password = passCtrl.text;
    // validation dans la view
    if (username.isEmpty || password.isEmpty) {
      setState(() => error = "Merci de remplir tous les champs.");
      return;
    }
    if (registerMode && username.length < 3) {
      setState(() => error = "Nom d’utilisateur trop court.");
      return;
    }
    if (registerMode && password.length < 6) {
      setState(() => error = "Mot de passe trop court.");
      return;
    }
    if (db == null) {
      setState(() => error = "DB non initialisée.");
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      if (registerMode) {
        // logique register + SQL dans la view
        final existing = await db!.query(
          'users',
          where: 'username = ?',
          whereArgs: [username],
          limit: 1,
        );
        if (existing.isNotEmpty) {
          setState(() => error = "Utilisateur déjà existant.");
          return;
        }
        await db!.insert('users', {
          'username': username,
          'password_hash': _hash(password),
        });
        // comportement UI mélangé à la logique
        registerMode = false;
        passCtrl.clear();
        setState(() => error = "Compte créé. Connecte-toi.");
      } else {
        // logique login + SQL dans la view
        final rows = await db!.query(
          'users',
          where: 'username = ?',
          whereArgs: [username],
          limit: 1,
        );
        if (rows.isEmpty) {
          setState(() => error = "Utilisateur introuvable.");
          return;
        }
        final storedHash = rows.first['password_hash'] as String;
        if (_hash(password) != storedHash) {
          setState(() => error = "Mot de passe incorrect.");
          return;
        }
        // navigation depuis la logique DB
        if (!mounted) return;
        Navigator.pushReplacement(
          context as BuildContext,
          MaterialPageRoute(builder: (_) => HomeMessy(username: username)),
        );
      }
    } catch (e) {
      setState(() => error = "Erreur: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    db?.close(); // la view gère aussi le cycle DB
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI + logique + DB dans un seul widget
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    registerMode ? Icons.person_add : Icons.lock_open,
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    registerMode ? "Inscription (Messy)" : "Connexion (Messy)",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: userCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nom d’utilisateur",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passCtrl,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => obscure = !obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              registerMode ? "Créer le compte" : "Se connecter",
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () {
                            setState(() {
                              registerMode = !registerMode;
                              error = null;
                            });
                          },
                    child: Text(
                      registerMode
                          ? "J’ai déjà un compte"
                          : "Créer un nouveau compte",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMessy extends StatelessWidget {
  final String username;
  const HomeMessy({super.key, required this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      body: Center(
        child: Text(
          "Bienvenue $username \n(Version désordonnée)",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
