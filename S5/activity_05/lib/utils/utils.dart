import 'package:activity_05/models/model_etudiant.dart';

class Utils {
  static double calculateMoyenne(List<Etudiant> etudiants) {
    double total = 0.0;
    for (var etudiant in etudiants) {
      total += etudiant.moyenne;
    }
    return total / etudiants.length;
  }
}
