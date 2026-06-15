import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maginfo_firebase/controllers/redacteur_controller.dart';
import 'package:maginfo_firebase/models/redacteur.dart';
import 'package:maginfo_firebase/utils/contants.dart';
import 'package:maginfo_firebase/views/add_redacteur_page.dart';
import 'package:maginfo_firebase/views/delete_redacteur_page.dart';
import 'package:maginfo_firebase/views/edit_redacteur_page.dart';

class RedacteurInfoPage extends StatefulWidget {
  final RedacteurController controller;
  const RedacteurInfoPage({super.key, required this.controller});

  @override
  State<RedacteurInfoPage> createState() => _RedacteurInfoPageState();
}

class _RedacteurInfoPageState extends State<RedacteurInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tous les rédacteurs'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      AddRedacteurPage(controller: widget.controller),
                ),
              );
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: widget.controller.redacteursStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erreur de chargement des rédacteurs.'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun rédacteur trouvé.'));
                }
                final redacteurs = snapshot.data!.docs
                    .map((doc) => Redacteur.fromFirestore(doc))
                    .toList();

                return ListView.builder(
                  itemCount: redacteurs.length,
                  itemBuilder: (context, index) {
                    final redacteur = redacteurs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(redacteur.nom),
                        subtitle: Text(redacteur.specialite),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => EditRedacteurPage(
                                      controller: widget.controller,
                                      redacteur: redacteur,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DeleteRedacteurPage(
                                      controller: widget.controller,
                                      redacteur: redacteur,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
