import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterfaceNotification extends StatelessWidget {
  const InterfaceNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference collectionUtilisateur = FirebaseFirestore.instance
        .collection('notification');

    return FutureBuilder<DocumentSnapshot>(
      future: collectionUtilisateur.doc('reussite').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("The document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;

              return Container(
                padding: const EdgeInsets.all(30),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.done, size: 40, color: Colors.green),
                        const SizedBox(width: 10),
                        Text(
                          data["sous_titre"],
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      data['texte'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }

            return Text("Chargement en cours ...");
          },
    );
  }
}
