import 'package:flutter/material.dart';

import '../../models/endroit.dart';
import '../endroit_detail.dart';

class EndroitsList extends StatelessWidget {
  const EndroitsList({super.key, required this.endroits});

  final List<Endroit> endroits;

  @override
  Widget build(BuildContext context) {
    if (endroits.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.place_outlined, size: 80),
            SizedBox(height: 10),
            Text('Aucun endroit ajouté', style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: endroits.length,
      itemBuilder: (context, index) {
        final endroit = endroits[index];

        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: FileImage(endroit.image),
          ),
          title: Text(endroit.nom),
          subtitle: endroit.adresse != null ? Text(endroit.adresse!) : null,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => EndroitDetail(endroit: endroit),
              ),
            );
          },
        );
      },
    );
  }
}
