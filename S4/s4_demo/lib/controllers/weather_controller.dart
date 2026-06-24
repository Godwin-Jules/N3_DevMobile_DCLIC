// ============================================================================
// FICHIER : weather_controller.dart
// COUCHE  : Contrôleur (C de MVC)
// RÔLE    : Faire le lien entre le Service (données) et la Vue (affichage).
//           Il gère l'ÉTAT de l'application (chargement, succès, erreur...)
//           et notifie automatiquement la Vue à chaque changement grâce à
//           ChangeNotifier (mécanisme du package Provider).
// ============================================================================

import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/weather_exceptions.dart';

// ----------------------------------------------------------------------------
// ÉNUMÉRATION DES ÉTATS POSSIBLES DE L'APPLICATION
// ----------------------------------------------------------------------------
// Plutôt qu'un simple booléen "isLoading" (qui ne peut représenter que deux
// états), une énumération permet de représenter PLUSIEURS états mutuellement
// exclusifs de façon claire et lisible. C'est un pattern très utilisé en
// gestion d'état Flutter.
enum WeatherStatus {
  /// L'application vient de démarrer, l'utilisateur n'a encore rien recherché.
  initial,

  /// Une requête HTTP est en cours d'exécution vers l'API.
  loading,

  /// Les données ont été reçues et parsées avec succès.
  success,

  /// Une erreur est survenue (réseau, ville introuvable, clé invalide...).
  error,
}

// ----------------------------------------------------------------------------
// LE CONTRÔLEUR
// ----------------------------------------------------------------------------
// "extends ChangeNotifier" est la clé du pattern Provider : cette classe
// peut désormais appeler notifyListeners(), ce qui prévient automatiquement
// tous les widgets qui "écoutent" ce contrôleur qu'ils doivent se redessiner.
class WeatherController extends ChangeNotifier {
  // Instance du service HTTP, utilisée pour effectuer les appels API.
  // Elle est privée : la Vue n'a JAMAIS accès directement au service,
  // elle doit toujours passer par le Contrôleur (respect strict du MVC).
  final WeatherService _weatherService = WeatherService();

  // -------------------- ATTRIBUTS PRIVÉS (l'état interne) --------------------
  // Tous préfixés par "_" : ils ne sont accessibles que DANS cette classe.
  // C'est ce qu'on appelle l'ENCAPSULATION : on protège l'état interne
  // contre toute modification accidentelle venant de l'extérieur (la Vue).

  /// État courant de l'application (initial, loading, success, error).
  WeatherStatus _status = WeatherStatus.initial;

  /// Les données météo actuellement affichées (null tant qu'on n'a rien reçu).
  /// Le "?" indique que cette variable PEUT être null (nullable).
  WeatherModel? _weather;

  /// Le message d'erreur à afficher si _status == WeatherStatus.error.
  String _errorMessage = '';

  /// Historique des villes recherchées, les plus récentes en premier.
  /// On en garde au maximum 5, comme demandé dans les consignes.
  final List<String> _searchHistory = [];

  // -------------------- GETTERS PUBLICS (lecture seule pour la Vue) --------------------
  // La Vue ne peut QUE LIRE ces valeurs via les getters ci-dessous.
  // Elle ne peut jamais faire "controller._status = ..." directement,
  // ce qui garantit que tout changement d'état passe par fetchWeather().

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  List<String> get searchHistory => _searchHistory;

  // Getters de "commodité" : évitent d'écrire des comparaisons répétitives
  // comme "controller.status == WeatherStatus.loading" dans toute la Vue.
  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasData => _status == WeatherStatus.success && _weather != null;
  bool get hasError => _status == WeatherStatus.error;

  // -------------------- MÉTHODE PRINCIPALE : fetchWeather() --------------------

  /// Récupère la météo d'une ville et met à jour l'état de l'application.
  /// C'est cette méthode que la Vue appelle quand l'utilisateur clique sur
  /// le bouton "Obtenir la météo".
  Future<void> fetchWeather(String cityName) async {
    // Sécurité : si le champ est vide, on ne fait rien (pas d'appel inutile).
    if (cityName.trim().isEmpty) return;

    // ÉTAPE 1 : on passe en état "loading" et on notifie la Vue.
    // Cela permet à l'interface d'afficher immédiatement un indicateur
    // de chargement (CircularProgressIndicator) pendant l'attente.
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      // ÉTAPE 2 : on délègue l'appel réseau au Service.
      // "await" met en pause cette méthode jusqu'à la réponse,
      // SANS bloquer l'interface utilisateur (l'app reste réactive).
      final WeatherModel result = await _weatherService.fetchWeather(
        cityName.trim(),
      );

      // ÉTAPE 3a : en cas de succès, on stocke le résultat
      // et on passe à l'état "success".
      _weather = result;
      _status = WeatherStatus.success;

      // On met à jour l'historique de recherche avec la ville trouvée.
      _addToHistory(result.cityName);
    }
    // ÉTAPE 3b : en cas d'erreur (n'importe laquelle de nos WeatherException),
    // on récupère son message déjà prêt à afficher et on passe à l'état "error".
    on WeatherException catch (e) {
      _errorMessage = e.message;
      _status = WeatherStatus.error;
    }
    // Filet de sécurité : si une erreur totalement inattendue survient
    // (bug, erreur de parsing non prévue...), on évite quand même
    // que l'application plante complètement.
    catch (e) {
      _errorMessage = 'Une erreur inattendue est survenue.';
      _status = WeatherStatus.error;
    }

    // ÉTAPE 4 : dans TOUS les cas (succès ou erreur), on notifie la Vue
    // pour qu'elle se redessine avec le nouvel état.
    notifyListeners();
  }

  // -------------------- GESTION DE L'HISTORIQUE --------------------

  /// Ajoute une ville à l'historique de recherche (max 5 villes,
  /// les plus récentes affichées en premier, sans doublons).
  void _addToHistory(String cityName) {
    // On retire d'abord la ville si elle existe déjà dans l'historique,
    // pour éviter les doublons et la remonter en première position.
    _searchHistory.removeWhere(
      (ville) => ville.toLowerCase() == cityName.toLowerCase(),
    );

    // On insère la nouvelle ville recherchée tout en haut de la liste (index 0).
    _searchHistory.insert(0, cityName);

    // Si l'historique dépasse 5 éléments, on supprime le plus ancien
    // (celui tout en bas de la liste).
    if (_searchHistory.length > 5) {
      _searchHistory.removeLast();
    }
  }

  /// Permet de relancer une recherche depuis l'historique (clic sur un "chip").
  void searchFromHistory(String cityName) {
    fetchWeather(cityName);
  }
}
