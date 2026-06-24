// ============================================================================
// FICHIER : weather_utils.dart
// COUCHE  : Utilitaires (fonctions d'aide pures, réutilisables)
// RÔLE    : Centraliser les petites fonctions de formatage et de conversion
//           utilisées par la Vue, pour éviter de dupliquer du code partout.
//           Ce sont des fonctions "pures" : elles prennent une entrée et
//           retournent une sortie, SANS effet de bord (pas de modification
//           d'état, pas d'appel réseau).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  // Constructeur privé (le "_" après le nom de la classe) : empêche
  // quiconque d'écrire "WeatherUtils()" pour créer une instance.
  // Cette classe ne sert que de "boîte à outils" de méthodes statiques.
  WeatherUtils._();

  // --------------------------------------------------------------------
  // 1. COULEURS DU DÉGRADÉ DE FOND SELON LA MÉTÉO
  // --------------------------------------------------------------------

  /// Retourne une liste de 2 couleurs (pour un dégradé) en fonction du code
  /// icône météo OpenWeather (ex: "01d", "04n", "10d"...).
  ///
  /// Rappel des codes OpenWeather :
  ///   01 = ciel dégagé      02 = peu nuageux      03/04 = nuageux
  ///   09/10 = pluie         11 = orage             13 = neige
  ///   50 = brouillard
  ///   Le dernier caractère indique le moment : "d" = jour (day), "n" = nuit (night)
  static List<Color> getGradientColors(String iconCode) {
    // On vérifie d'abord si on est de nuit : tous les codes se terminant
    // par "n" auront une teinte plus sombre, peu importe la météo.
    final bool isNight = iconCode.endsWith('n');

    if (isNight) {
      // Nuit : dégradé bleu marine très foncé (cas "n" du PDF)
      return const [Color(0xFF0F2447), Color(0xFF1A1A2E)];
    }

    // On utilise startsWith() pour regrouper les codes par "famille" météo
    // (ex: "01d" et "01n" partagent le même préfixe "01").
    if (iconCode.startsWith('01')) {
      // 01 = soleil → dégradé bleu ciel
      return const [Color(0xFF4FACFE), Color(0xFF00C6FB)];
    } else if (iconCode.startsWith('02') || iconCode.startsWith('03')) {
      // 02/03 = peu nuageux → dégradé bleu clair/gris doux
      return const [Color(0xFF6DD5FA), Color(0xFF87A8D0)];
    } else if (iconCode.startsWith('04')) {
      // 04 = nuages → dégradé gris bleu (cas du PDF)
      return const [Color(0xFF757F9A), Color(0xFFD7DDE8)];
    } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      // 09/10 = pluie → dégradé bleu foncé (cas du PDF)
      return const [Color(0xFF1E3C72), Color(0xFF2A5298)];
    } else if (iconCode.startsWith('11')) {
      // 11 = orage → dégradé violet sombre / gris anthracite
      return const [Color(0xFF373B44), Color(0xFF4286F4)];
    } else if (iconCode.startsWith('13')) {
      // 13 = neige → dégradé blanc bleuté
      return const [Color(0xFFE6DADA), Color(0xFF274046)];
    } else if (iconCode.startsWith('50')) {
      // 50 = brouillard → dégradé gris clair
      return const [Color(0xFFBDC3C7), Color(0xFF2C3E50)];
    }

    // Cas par défaut (sécurité) : dégradé bleu standard.
    return const [Color(0xFF4FACFE), Color(0xFF00C6FB)];
  }

  // --------------------------------------------------------------------
  // 2. EMOJI MÉTÉO
  // --------------------------------------------------------------------

  /// Retourne un emoji représentatif selon le code icône OpenWeather.
  /// Même logique de regroupement par préfixe que getGradientColors().
  static String getWeatherEmoji(String iconCode) {
    final bool isNight = iconCode.endsWith('n');

    if (iconCode.startsWith('01')) {
      return isNight ? '🌙' : '☀️';
    } else if (iconCode.startsWith('02')) {
      return isNight ? '🌤️' : '⛅';
    } else if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
      return '☁️';
    } else if (iconCode.startsWith('09')) {
      return '🌧️';
    } else if (iconCode.startsWith('10')) {
      return isNight ? '🌧️' : '🌦️';
    } else if (iconCode.startsWith('11')) {
      return '⛈️';
    } else if (iconCode.startsWith('13')) {
      return '❄️';
    } else if (iconCode.startsWith('50')) {
      return '🌫️';
    }

    // Valeur par défaut si le code n'est pas reconnu.
    return '🌡️';
  }

  // --------------------------------------------------------------------
  // 3. FORMATAGE DE LA TEMPÉRATURE
  // --------------------------------------------------------------------

  /// Formate une température en chaîne lisible, ex: 17.456 → "17°C"
  /// .round() arrondit à l'entier le plus proche (pas de virgule affichée,
  /// plus lisible pour l'utilisateur final).
  static String formatTemp(double temp) {
    return '${temp.round()}°C';
  }

  // --------------------------------------------------------------------
  // 4. FORMATAGE DE L'HEURE
  // --------------------------------------------------------------------

  /// Formate une DateTime en heure au format HH:mm, ex: 6h05 → "06:05"
  /// DateFormat vient du package "intl".
  static String formatTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  // --------------------------------------------------------------------
  // 5. FORMATAGE DE LA DATE EN FRANÇAIS
  // --------------------------------------------------------------------

  /// Formate une DateTime en date complète française,
  /// ex: → "mercredi 8 avril 2026"
  /// Le second paramètre 'fr_FR' indique la locale (langue + pays) à utiliser :
  /// nécessite que initializeDateFormatting('fr_FR') ait été appelé
  /// au démarrage de l'app (voir main.dart).
  static String formatDate(DateTime dt) {
    return DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(dt);
  }

  // --------------------------------------------------------------------
  // 6. MISE EN MAJUSCULE DE LA PREMIÈRE LETTRE
  // --------------------------------------------------------------------

  /// Met en majuscule la première lettre d'une chaîne,
  /// ex: "ciel dégagé" → "Ciel dégagé"
  /// Utile car l'API OpenWeather renvoie les descriptions tout en minuscules.
  static String capitalize(String s) {
    // Sécurité : si la chaîne est vide, on la retourne telle quelle
    // (évite un crash en essayant d'accéder au caractère [0]).
    if (s.isEmpty) return s;

    // s[0] = premier caractère, .toUpperCase() le met en majuscule.
    // s.substring(1) = tout le reste de la chaîne, inchangé.
    return s[0].toUpperCase() + s.substring(1);
  }

  // --------------------------------------------------------------------
  // 7. CONVERSION DE LA DIRECTION DU VENT (bonus pratique)
  // --------------------------------------------------------------------

  /// Convertit un angle en degrés (0-360) en point cardinal abrégé,
  /// ex: 40° → "NE", utilisé dans la carte "Vent" de l'interface.
  static String degreesToCardinal(int degrees) {
    const List<String> directions = [
      'N',
      'NE',
      'E',
      'SE',
      'S',
      'SO',
      'O',
      'NO',
    ];
    // On divise le cercle (360°) en 8 secteurs de 45° chacun,
    // puis on arrondit pour trouver l'index du secteur correspondant.
    final int index = ((degrees / 45) + 0.5).floor() % 8;
    return directions[index];
  }
}
