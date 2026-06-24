// ============================================================================
// FICHIER : weather_service.dart
// COUCHE  : Service (couche technique, à part du M-V-C classique)
// RÔLE    : Effectuer l'appel réseau vers l'API OpenWeather et retourner soit
//           un WeatherModel (succès), soit lever une exception (échec).
//           Cette classe NE GÈRE NI L'AFFICHAGE NI L'ÉTAT DE L'APPLICATION :
//           c'est le Contrôleur qui s'en chargera.
// ============================================================================

// Import du package "http" : permet d'envoyer des requêtes HTTP (GET, POST...)
import 'package:http/http.dart' as http;

// "dart:convert" fournit jsonDecode() pour transformer une chaîne JSON brute
// (texte) en structure Dart exploitable (Map, List...).
import 'dart:convert';

import '../models/weather_model.dart';
import 'api_config.dart';
import 'weather_exceptions.dart';

class WeatherService {
  /// Méthode principale et unique du service : récupère la météo d'une ville.
  ///
  /// "Future<WeatherModel>" signifie que cette méthode est ASYNCHRONE :
  /// elle ne retourne pas immédiatement un WeatherModel, mais une "promesse"
  /// qu'on pourra "attendre" (await) plus tard, le temps que la requête
  /// réseau se termine.
  Future<WeatherModel> fetchWeather(String cityName) async {
    // On encapsule TOUT l'appel réseau dans un try/catch.
    // Cela permet de capturer les erreurs "basses couches" : pas de
    // connexion internet, DNS introuvable, timeout, etc. — des erreurs qui
    // surviennent AVANT même de recevoir une réponse HTTP avec un code.
    try {
      // Construction de l'URL complète avec les paramètres de requête.
      // Uri.parse() transforme une chaîne de caractères en objet Uri valide.
      //
      // Paramètres de l'URL :
      //   q       = nom de la ville recherchée
      //   appid   = notre clé API personnelle
      //   units   = metric (températures en Celsius, pas en Kelvin)
      //   lang    = fr (descriptions météo en français)
      final Uri url = Uri.parse(
        '${ApiConfig.baseUrl}?q=$cityName&appid=${ApiConfig.apiKey}&units=metric&lang=fr',
      );

      // Envoi de la requête HTTP GET et attente (await) de la réponse.
      // "await" met en pause cette fonction (sans bloquer toute l'app)
      // jusqu'à ce que la réponse du serveur arrive.
      final http.Response response = await http.get(url);

      // On analyse le code de statut HTTP renvoyé par le serveur pour
      // décider quoi faire. C'est le "switch" recommandé dans le PDF.
      switch (response.statusCode) {
        // ---------------- CAS 200 : SUCCÈS ----------------
        case 200:
          // jsonDecode() transforme le texte JSON brut (response.body)
          // en structure Dart (ici, un Map<String, dynamic>).
          final Map<String, dynamic> data =
              jsonDecode(response.body) as Map<String, dynamic>;

          // On délègue le parsing détaillé au Modèle lui-même,
          // via son factory constructor fromJson().
          return WeatherModel.fromJson(data);

        // ---------------- CAS 401 : CLÉ API INVALIDE ----------------
        case 401:
          throw InvalidApiKeyException();

        // ---------------- CAS 404 : VILLE INTROUVABLE ----------------
        case 404:
          throw CityNotFoundException(cityName);

        // ---------------- CAS 429 : TROP DE REQUÊTES ----------------
        case 429:
          throw TooManyRequestsException();

        // ---------------- TOUT AUTRE CODE : ERREUR SERVEUR ----------------
        default:
          throw ServerErrorException(response.statusCode);
      }
    }
    // Si l'exception est déjà une de nos WeatherException personnalisées
    // (401, 404, 429, 500...), on la relance TELLE QUELLE sans la modifier.
    // Cela évite qu'elle soit "avalée" par le catch générique juste après.
    on WeatherException {
      rethrow;
    }
    // Toute autre erreur (pas de réseau, timeout, format JSON invalide...)
    // est traduite en NetworkException, avec un message clair pour
    // l'utilisateur final qui ne comprendrait pas une erreur technique brute.
    catch (e) {
      throw NetworkException();
    }
  }
}
