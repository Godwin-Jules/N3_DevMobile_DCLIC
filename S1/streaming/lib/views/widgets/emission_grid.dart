import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../models/emission.dart';
import 'emission_card.dart';

class EmissionGrid extends StatelessWidget {
  final List<Emission> emissions;
  final Function(Emission) onTap;

  const EmissionGrid({super.key, required this.emissions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      desiredItemWidth: 180,
      minSpacing: 12,
      children: emissions.map((emission) {
        return SizedBox(
          height: 260,
          child: EmissionCard(emission: emission, onTap: () => onTap(emission)),
        );
      }).toList(),
    );
  }
}
