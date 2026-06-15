import 'package:flutter/material.dart';
import 'package:maginfo_firebase/controllers/redacteur_controller.dart';
import 'package:maginfo_firebase/models/redacteur.dart';
import 'package:maginfo_firebase/utils/contants.dart';

class EditRedacteurPage extends StatefulWidget {
  final RedacteurController controller;
  final Redacteur redacteur;

  const EditRedacteurPage({
    super.key,
    required this.controller,
    required this.redacteur,
  });

  @override
  State<EditRedacteurPage> createState() => _EditRedacteurPageState();
}

class _EditRedacteurPageState extends State<EditRedacteurPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _specialiteController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.redacteur.nom);
    _specialiteController = TextEditingController(
      text: widget.redacteur.specialite,
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  Future<void> _saveRedacteur() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.controller.editRedacteur(
      widget.redacteur.id,
      _nomController.text.trim(),
      _specialiteController.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rédacteur modifié avec succès')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le rédacteur'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Champ requis'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(labelText: 'Spécialité'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Champ requis'
                    : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveRedacteur,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Enregistrer les modifications'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
