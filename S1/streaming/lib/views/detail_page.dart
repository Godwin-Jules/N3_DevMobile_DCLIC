import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/diffusion.dart';
import '../models/emission.dart';

class DetailPage extends StatelessWidget {
  final Emission emission;
  final List<Diffusion> diffusions;

  const DetailPage({
    super.key,
    required this.emission,
    required this.diffusions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(emission.nom), backgroundColor: Colors.amber),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: emission.id,
              child: Image.asset(
                emission.image,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              emission.nom,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            Text(emission.chaine, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 25),

            const Text(
              "Diffusions récentes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            const SizedBox(height: 10),

            ...diffusions.map(
              (diffusion) => ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.amber),
                title: Text(diffusion.titre),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(diffusion.date)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
