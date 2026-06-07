import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Endroit {
  final String id;
  final String nom;
  final File image;

  final double? latitude;
  final double? longitude;
  final String? adresse;

  Endroit({
    required this.nom,
    required this.image,
    this.latitude,
    this.longitude,
    this.adresse,
  }) : id = uuid.v4();

  bool get aLocalisation {
    return latitude != null && longitude != null;
  }
}
