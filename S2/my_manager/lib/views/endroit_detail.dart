import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/endroit.dart';

class EndroitDetail extends StatelessWidget {
  const EndroitDetail({super.key, required this.endroit});

  final Endroit endroit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(endroit.nom)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.file(endroit.image, height: 250, fit: BoxFit.cover),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              endroit.nom,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          if (endroit.adresse != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(endroit.adresse!),
            ),

          const SizedBox(height: 10),

          if (endroit.aLocalisation)
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(endroit.latitude!, endroit.longitude!),
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('endroit'),
                    position: LatLng(endroit.latitude!, endroit.longitude!),
                  ),
                },
              ),
            ),
        ],
      ),
    );
  }
}
