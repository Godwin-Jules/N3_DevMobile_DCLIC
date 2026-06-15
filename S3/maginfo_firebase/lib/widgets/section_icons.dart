import 'package:flutter/material.dart';

class SectionIcons extends StatelessWidget {
  const SectionIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _IconAction(icon: Icons.phone, label: "TEL"),
          _IconAction(icon: Icons.email, label: "MAIL"),
          _IconAction(icon: Icons.share, label: "PARTAGE"),
        ],
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon, color: Color.fromARGB(255, 255, 70, 14)),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 70, 14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
