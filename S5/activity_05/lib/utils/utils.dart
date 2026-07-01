import 'package:activity_05/models/model_etudiant.dart';

class Utils {
  Utils._();

  static double calculateMoyenne(List<Etudiant> etudiants) {
    if (etudiants.isEmpty) return 0.0;

    double total = 0.0;
    for (var etudiant in etudiants) {
      total += etudiant.moyenne;
    }
    return total / etudiants.length;
  }
}
