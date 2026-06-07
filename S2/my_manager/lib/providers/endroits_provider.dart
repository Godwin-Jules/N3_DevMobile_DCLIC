import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/endroit.dart';

class EndroitsNotifier extends Notifier<List<Endroit>> {
  @override
  List<Endroit> build() {
    return [];
  }

  void ajouterEndroit({
    required String nom,
    required File image,
    double? latitude,
    double? longitude,
    String? adresse,
  }) {
    final nouvelEndroit = Endroit(
      nom: nom,
      image: image,
      latitude: latitude,
      longitude: longitude,
      adresse: adresse,
    );

    state = [nouvelEndroit, ...state];
  }

  void supprimerEndroit(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final endroitsProvider = NotifierProvider<EndroitsNotifier, List<Endroit>>(
  EndroitsNotifier.new,
);
