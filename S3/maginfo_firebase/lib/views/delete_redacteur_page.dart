import 'package:flutter/material.dart';
import 'package:maginfo_firebase/controllers/redacteur_controller.dart';
import 'package:maginfo_firebase/models/redacteur.dart';
import 'package:maginfo_firebase/utils/contants.dart';

class DeleteRedacteurPage extends StatelessWidget {
  final RedacteurController controller;
  final Redacteur redacteur;

  const DeleteRedacteurPage({
    super.key,
    required this.controller,
    required this.redacteur,
  });

  Future<void> _deleteRedacteur(BuildContext context) async {
    await controller.removeRedacteur(redacteur.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rédacteur supprimé avec succès')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supprimer le rédacteur'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voulez-vous vraiment supprimer ce rédacteur ?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Nom : ${redacteur.nom}'),
            const SizedBox(height: 8),
            Text('Spécialité : ${redacteur.specialite}'),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _deleteRedacteur(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Supprimer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
