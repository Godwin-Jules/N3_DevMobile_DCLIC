import 'package:flutter/material.dart';
import 'package:streaming/views/widgets/emission_grid.dart';

import '../controllers/emission_controller.dart';
import '../models/emission.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  final EmissionController controller;

  const HomePage({super.key, required this.controller});

  void ouvrirDetail(BuildContext context, Emission emission) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          emission: emission,
          diffusions: controller.getDiffusions(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emissions = controller.getEmissions();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Vos émissions en streaming"),
        actions: const [
          Padding(padding: EdgeInsets.all(8), child: Icon(Icons.search)),
          Padding(padding: EdgeInsets.all(8), child: Icon(Icons.list)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: EmissionGrid(
          emissions: emissions,
          onTap: (emission) => ouvrirDetail(context, emission),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
