import 'package:flutter/material.dart';

void main() {
  runApp(MonApplication());
}

class Etudiant {
  final String nom;
  final double moyenne;
  Etudiant({required this.nom, required this.moyenne});
}

class MonApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageAccueil(),
      routes: {'/details': (context) => DetailPage()},
    );
  }
}

class PageAccueil extends StatelessWidget {
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
appBar: AppBar(
title: Text('Liste des étudiants'),
),
body: Padding(
padding:EdgeInsets.all(16.0),
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
margin: EdgeInsets.only(
bottom: 16.0),
decoration: BoxDecoration(
color: Colors.grey[200],
borderRadius:
BorderRadius.circular(10.0),
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
child: Text('Calculer la moyenne de la classe’),
onPressed: () {
final average = calculateMoyenne(etudiants);
moyenneAlertDialog(context, average); // Afficher l'alerte
},
),
],
),
),
);
}
double calculateMoyenne(List<Etudiant> etudiants) {
double total = 0.0;
for (var etudiant in etudiants) {
var total = 0;
total += etudiant.moyenne as int;
}
return total / etudiants.length;
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

class DetailPage extends StatelessWidget {
@override
Widget build(BuildContext context) {
final etudiant = ModalRoute.of(context)!.settings.arguments as Etudiant;
return Scaffold(
appBar: AppBar(
title: Text('Détails de l\'étudiant'),
),
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