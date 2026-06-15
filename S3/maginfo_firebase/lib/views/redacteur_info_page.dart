import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maginfo_firebase/controllers/redacteur_controller.dart';
import 'package:maginfo_firebase/models/redacteur.dart';
import 'package:maginfo_firebase/utils/contants.dart';

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
        title: Text('Tous les rédacteurs'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {},
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: controller.redacteursStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('Aucun rédacteur trouvé.');
              }
              final redacteurs = snapshot.data!.docs
                  .map((doc) => Redacteur.fromFirestore(doc))
                  .toList();

              return ListView.builder(
                itemCount: redacteurs.length,
                itemBuilder: (context, index) {
                  final redacteur = redacteurs[index];
                  return Card(
                    child: ListTile(
                      title: Text(redacteur.nom),
                      subtitle: Text(redacteur.specialite),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
