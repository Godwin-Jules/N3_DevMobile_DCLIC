import 'package:activity_05/models/model_etudiant.dart';
import 'package:activity_05/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test unitaire de calcul de la moyenne de la classe", () {
    test(
      "Cas simple : seulement deux étudiants (10.0 et 14.0) doit retourner 12.0",
      () {
        final listEtudiants = [
          Etudiant(nom: 'Eleve 1', moyenne: 10.0),
          Etudiant(nom: 'Elève 2', moyenne: 14.0),
        ];

        final resultat = Utils.calculateMoyenne(listEtudiants);

        expect(resultat, equals(12.0));
      },
    );

    test("Cas varié : moyennes réelles de l'énoncé doit retourner 14.35", () {
      final listeEtudiants = [
        Etudiant(nom: 'Alice', moyenne: 17.25),
        Etudiant(nom: 'Bob', moyenne: 16.5),
        Etudiant(nom: 'Charlie', moyenne: 11.75),
        Etudiant(nom: 'David', moyenne: 12.75),
        Etudiant(nom: 'Eve', moyenne: 13.5),
      ];

      final resultat = Utils.calculateMoyenne(listeEtudiants);

      expect(resultat, closeTo(14.35, 0.01));
    });

    test('Cas limite : liste vide doit retourner 0.0', () {
      final List<Etudiant> listeVide = [];
      final resultat = Utils.calculateMoyenne(listeVide);
      expect(resultat, equals(0.0));
    });
  });
}
