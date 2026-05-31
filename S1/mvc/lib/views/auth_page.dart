import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  final AuthController controller;
  const AuthPage({super.key, required this.controller});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isRegister = false;
  bool _obscure = true;
  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _submit() async {
    _dismissKeyboard();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final username = _userCtrl.text;
    final password = _passCtrl.text;
    final ok = _isRegister
        ? await widget.controller.register(username, password)
        : await widget.controller.login(username, password);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(controller: widget.controller),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final c = widget.controller;
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
                      _Header(isRegister: _isRegister),
                      const SizedBox(height: 18),
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _userCtrl,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: "Nom d’utilisateur",
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (v) {
                                    final s = (v ?? "").trim();
                                    if (s.isEmpty) return "Champ obligatoire";
                                    if (_isRegister && s.length < 3) {
                                      return "Au moins 3 caractères";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _passCtrl,
                                  obscureText: _obscure,
                                  decoration: InputDecoration(
                                    labelText: "Mot de passe",
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                      icon: Icon(
                                        _obscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                  validator: (v) {
                                    final s = (v ?? "");
                                    if (s.isEmpty) return "Champ obligatoire";
                                    if (_isRegister && s.length < 6) {
                                      return "Au moins 6 caractères";
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                                const SizedBox(height: 14),
                                if (c.error != null)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            c.error!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton(
                                    onPressed: c.loading ? null : _submit,
                                    child: c.loading
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Text(
                                            _isRegister
                                                ? "Créer un compte"
                                                : "Se connecter",
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: c.loading
                                      ? null
                                      : () {
                                          setState(
                                            () => _isRegister = !_isRegister,
                                          );
                                          widget.controller.clearError();
                                        },
                                  child: Text(
                                    _isRegister
                                        ? "J’ai déjà un compte"
                                        : "Créer un nouveau compte",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "Version MVC : View (UI) / Controller (logique) / Model+Data (sqflite).",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final bool isRegister;
  const _Header({required this.isRegister});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 62,
          width: 62,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
          ),
          child: Icon(
            isRegister ? Icons.person_add_alt_1 : Icons.lock_open,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isRegister ? "Inscription (MVC)" : "Connexion (MVC)",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          "sqflite + séparation des responsabilités",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
