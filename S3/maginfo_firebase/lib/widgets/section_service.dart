import 'package:flutter/material.dart';

class SectionService extends StatelessWidget {
  const SectionService({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SquareImage(imagePath: 'assets/images/presse.png'),
          _SquareImage(imagePath: 'assets/images/coworking.avif'),
        ],
      ),
    );
  }
}

class _SquareImage extends StatelessWidget {
  final String imagePath;

  const _SquareImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        imagePath,
        width: MediaQuery.of(context).size.width * 0.42,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}
