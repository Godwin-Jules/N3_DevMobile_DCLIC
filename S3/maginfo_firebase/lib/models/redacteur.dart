import 'package:cloud_firestore/cloud_firestore.dart';

class Redacteur {
  final String id;
  final String nom;
  final String specialite;

  Redacteur({required this.id, required this.nom, required this.specialite});

  factory Redacteur.fromFirestore(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>;

    return Redacteur(
      id: document.id,
      nom: data['nom'] ?? '',
      specialite: data['specialite'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'nom': nom, 'specialite': specialite};
  }
}
