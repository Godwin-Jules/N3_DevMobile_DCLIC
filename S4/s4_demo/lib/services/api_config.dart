// ============================================================================
// FICHIER : api_config.dart
// RÔLE    : Centraliser la configuration sensible (clé API) dans UN SEUL fichier.
//
// POURQUOI UN FICHIER À PART ?
// C'est une BONNE PRATIQUE à enseigner aux apprenants : on ne disperse jamais
// une clé API dans plusieurs fichiers. On la met à un seul endroit, ce qui
// permet de :
//   1. La changer facilement (une seule ligne à modifier)
//   2. L'exclure du dépôt Git via .gitignore si le projet est rendu public
//      (dans un vrai projet professionnel, ce fichier ne serait PAS commit)
// ============================================================================

class ApiConfig {
  // Constructeur privé : empêche quiconque de faire "ApiConfig()".
  // Cette classe ne sert qu'à porter des constantes statiques.
  ApiConfig._();

  /// Clé API personnelle obtenue sur https://openweathermap.org
  /// (section "API Keys" du tableau de bord, après inscription gratuite).
  static const String apiKey = '114807c822a2f7077a012ee9bc4a7fb2';

  /// URL de base de l'API OpenWeather pour les prévisions météo actuelles.
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
}
