class WeatherException implements Exception {
  final String message;

  WeatherException(this.message);

  @override
  String toString() => message;
}

class InvalidApiKeyException extends WeatherException {
  InvalidApiKeyException()
    : super('Votre clé API est invalide. Vérifiez votre configuration.');
}

class CityNotFoundException extends WeatherException {
  CityNotFoundException(String city)
    : super('Ville "$city" introuvable. Vérifiez l\'orthographe.');
}

class TooManyRequestsException extends WeatherException {
  TooManyRequestsException()
    : super('Vous avez atteint la limite de requêtes. Réessayez plus tard.');
}

class ServerErrorException extends WeatherException {
  ServerErrorException(int statusCode) : super('Erreur serveur ($statusCode).');
}

class NetworkException extends WeatherException {
  NetworkException()
    : super('Pas de connexion internet. Vérifiez votre réseau.');
}
