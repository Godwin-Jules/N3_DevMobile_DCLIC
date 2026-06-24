// ============================================================================
// FICHIER : weather_exceptions.dart
// RÔLE    : Définir des erreurs "métier" spécifiques à l'application météo,
//           plutôt que de propager des erreurs HTTP génériques.
//
// POURQUOI DES EXCEPTIONS PERSONNALISÉES ?
// Plutôt que de faire "throw Exception('erreur')" partout (texte générique
// difficile à exploiter), on crée une classe d'erreur DÉDIÉE qui porte un
// message déjà prêt à être affiché à l'utilisateur. Le Contrôleur n'aura
// alors qu'à lire exception.message sans avoir à connaître les détails HTTP.
// ============================================================================

/// Classe de base pour toutes les erreurs liées à la météo.
/// "implements Exception" permet d'utiliser "throw WeatherException(...)"
/// comme n'importe quelle exception standard de Dart.
class WeatherException implements Exception {
  /// Le message d'erreur, déjà rédigé en français, prêt à être affiché
  /// directement dans l'interface utilisateur (WeatherErrorWidget).
  final String message;

  WeatherException(this.message);

  // On surcharge toString() pour que l'erreur s'affiche proprement
  // si jamais elle apparaît dans les logs/la console de débogage.
  @override
  String toString() => message;
}

/// Erreur spécifique : clé API invalide ou absente (code HTTP 401).
class InvalidApiKeyException extends WeatherException {
  InvalidApiKeyException()
    : super('Clé API invalide. Vérifiez votre configuration.');
}

/// Erreur spécifique : ville introuvable (code HTTP 404).
/// On passe le nom de la ville recherchée pour personnaliser le message.
class CityNotFoundException extends WeatherException {
  CityNotFoundException(String cityName)
    : super('Ville "$cityName" introuvable. Vérifiez l\'orthographe.');
}

/// Erreur spécifique : trop de requêtes envoyées (code HTTP 429).
class TooManyRequestsException extends WeatherException {
  TooManyRequestsException()
    : super('Limite de requêtes atteinte. Réessayez plus tard.');
}

/// Erreur spécifique : erreur côté serveur OpenWeather (tout autre code).
/// On garde le code HTTP dans le message pour faciliter le débogage.
class ServerErrorException extends WeatherException {
  ServerErrorException(int statusCode) : super('Erreur serveur ($statusCode).');
}

/// Erreur spécifique : pas de connexion internet, DNS injoignable, etc.
/// Cette erreur est levée quand l'appel http lui-même échoue (avant même
/// de recevoir une réponse avec un code de statut).
class NetworkException extends WeatherException {
  NetworkException()
    : super('Pas de connexion internet. Vérifiez votre réseau.');
}
