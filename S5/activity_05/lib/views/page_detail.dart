import 'package:activity_05/models/model_etudiant.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final etudiant = ModalRoute.of(context)!.settings.arguments as Etudiant;

    return Scaffold(
      appBar: AppBar(title: Text('Détails de l\'étudiant')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nom de l\'étudiant : ${etudiant.nom}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Moyenne : ${etudiant.moyenne}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
