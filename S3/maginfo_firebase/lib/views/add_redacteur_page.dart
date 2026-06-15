import 'package:flutter/material.dart';
import 'package:maginfo_firebase/controllers/redacteur_controller.dart';
import 'package:maginfo_firebase/utils/contants.dart';

class AddRedacteurPage extends StatefulWidget {
  final RedacteurController controller;
  const AddRedacteurPage({super.key, required this.controller});

  @override
  State<AddRedacteurPage> createState() => _AddRedacteurPageState();
}

class _AddRedacteurPageState extends State<AddRedacteurPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _specialiteController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  Future<void> _addRedacteur() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await widget.controller.addRedacteur(
      _nomController.text.trim(),
      _specialiteController.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rédacteur ajouté avec succès')),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddRedacteurPage(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un rédacteur'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
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
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(labelText: 'Spécialité'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _addRedacteur,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Ajouter un rédacteur',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
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
