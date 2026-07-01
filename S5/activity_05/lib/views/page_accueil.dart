import 'package:activity_05/models/model_etudiant.dart';
import 'package:activity_05/utils/utils.dart';
import 'package:flutter/material.dart';

class PageAccueil extends StatelessWidget {
  PageAccueil({super.key});

  final List<Etudiant> etudiants = [
    Etudiant(nom: 'Alice', moyenne: 17.25),
    Etudiant(nom: 'Bob', moyenne: 16.5),
    Etudiant(nom: 'Charlie', moyenne: 11.75),
    Etudiant(nom: 'David', moyenne: 12.75),
    Etudiant(nom: 'Eve', moyenne: 13.5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des étudiants')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Liste des étudiants et de leurs moyennes :',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: etudiants.length,
                itemBuilder: (context, index) {
                  final etudiant = etudiants[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text('Nom: ${etudiant.nom}'),
                      subtitle: Text('Moyenne : ${etudiant.moyenne}'),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: etudiant,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text('Calculer la moyenne de la classe'),
              onPressed: () {
                final average = Utils.calculateMoyenne(etudiants);
                moyenneAlertDialog(context, average); // Afficher l'alerte
              },
            ),
          ],
        ),
      ),
    );
  }

  void moyenneAlertDialog(BuildContext context, double average) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Moyenne des étudiants'),
          content: Text('La moyenne des étudiants est : $average'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
