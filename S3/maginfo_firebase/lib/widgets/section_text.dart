import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  const SectionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        "Magazine Infos est bien plus qu'un simple magazine d'informations. C'est votre passerelle vers le monde, une source inestimable de connaissances et d'actualités soigneusement sélectionnées pour vous éclairer sur les enjeux mondiaux, la culture, la science, la, et voir même le divertissement (le jeux).",
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
