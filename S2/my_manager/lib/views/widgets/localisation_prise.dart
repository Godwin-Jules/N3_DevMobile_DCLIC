import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocalisationPrise extends StatefulWidget {
  const LocalisationPrise({
    super.key,
    required this.onLocalisationSelectionnee,
  });

  final void Function(double lat, double lng, String adresse)
  onLocalisationSelectionnee;

  @override
  State<LocalisationPrise> createState() => _LocalisationPriseState();
}

class _LocalisationPriseState extends State<LocalisationPrise> {
  double? _latitude;
  double? _longitude;
  String? _adresse;
  bool _chargement = false;

  Future<void> _obtenirLocalisation() async {
    setState(() {
      _chargement = true;
    });

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;

    final adresse = '${place.locality}, ${place.country}';

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _adresse = adresse;
      _chargement = false;
    });

    widget.onLocalisationSelectionnee(
      position.latitude,
      position.longitude,
      adresse,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget contenu;

    if (_chargement) {
      contenu = const Center(child: CircularProgressIndicator());
    } else if (_latitude != null && _longitude != null) {
      contenu = Column(
        children: [
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude!, _longitude!),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('position'),
                  position: LatLng(_latitude!, _longitude!),
                ),
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(_adresse ?? ''),
        ],
      );
    } else {
      contenu = OutlinedButton.icon(
        onPressed: _obtenirLocalisation,
        icon: const Icon(Icons.location_on),
        label: const Text('Obtenir ma localisation'),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: contenu,
    );
  }
}
