// ============================================================================
// FICHIER : weather_model.dart
// COUCHE  : Modèle (M de MVC)
// RÔLE    : Représenter et structurer les données météo renvoyées par l'API.
//           Cette classe NE CONTIENT AUCUNE LOGIQUE MÉTIER NI WIDGET.
//           Son seul travail : transformer un JSON brut en objet Dart utilisable.
// ============================================================================

/// Classe qui représente toutes les données météorologiques d'une ville,
/// telles que renvoyées par l'API OpenWeather (endpoint /weather).
///
/// Tous les attributs sont "final" : une fois l'objet créé, ses valeurs
/// ne changent plus jamais. C'est ce qu'on appelle l'IMMUTABILITÉ.
/// Avantage pédagogique : un WeatherModel représente une "photo" figée
/// de la météo à un instant T, ce qui évite les bugs liés à un état
/// qui changerait de manière inattendue.
class WeatherModel {
  // -------------------- ATTRIBUTS (les données du modèle) --------------------

  /// Nom de la ville, ex: "Paris"
  /// Vient du champ JSON racine : "name"
  final String cityName;

  /// Code pays à 2 lettres, ex: "FR"
  /// Vient du champ JSON imbriqué : "sys" -> "country"
  final String country;

  /// Température actuelle en degrés Celsius (car on demande units=metric)
  /// Vient du champ JSON imbriqué : "main" -> "temp"
  final double temperature;

  /// Température "ressentie" (prend en compte le vent, l'humidité...)
  /// Vient du champ JSON imbriqué : "main" -> "feels_like"
  final double feelsLike;

  /// Température minimale prévue dans la zone/journée
  /// Vient du champ JSON imbriqué : "main" -> "temp_min"
  final double tempMin;

  /// Température maximale prévue dans la zone/journée
  /// Vient du champ JSON imbriqué : "main" -> "temp_max"
  final double tempMax;

  /// Taux d'humidité en pourcentage (0 à 100)
  /// Vient du champ JSON imbriqué : "main" -> "humidity"
  final int humidity;

  /// Pression atmosphérique en hectopascals (hPa)
  /// Vient du champ JSON imbriqué : "main" -> "pressure"
  final int pressure;

  /// Vitesse du vent en mètres par seconde (m/s)
  /// Vient du champ JSON imbriqué : "wind" -> "speed"
  final double windSpeed;

  /// Direction du vent en degrés (0° = Nord, 90° = Est, etc.)
  /// Vient du champ JSON imbriqué : "wind" -> "deg"
  final int windDegree;

  /// Description textuelle de la météo, ex: "ciel dégagé"
  /// (en français car on demande lang=fr dans l'URL de l'API)
  /// Vient du champ JSON imbriqué : "weather" -> [0] -> "description"
  final String description;

  /// Code icône météo OpenWeather, ex: "01d" (soleil de jour), "04n" (nuages de nuit)
  /// Ce code sert ensuite à choisir un emoji et une couleur de dégradé (voir WeatherUtils)
  /// Vient du champ JSON imbriqué : "weather" -> [0] -> "icon"
  final String iconCode;

  /// Visibilité en mètres (on la convertira en km dans l'affichage)
  /// Vient du champ JSON racine : "visibility"
  final int visibility;

  /// Heure du lever du soleil (convertie depuis un timestamp Unix)
  /// Vient du champ JSON imbriqué : "sys" -> "sunrise"
  final DateTime sunrise;

  /// Heure du coucher du soleil (convertie depuis un timestamp Unix)
  /// Vient du champ JSON imbriqué : "sys" -> "sunset"
  final DateTime sunset;

  // -------------------- CONSTRUCTEUR --------------------

  /// Constructeur "normal" : on doit fournir TOUTES les valeurs (required)
  /// car on a choisi des attributs "final" non-nullables.
  /// C'est ce constructeur qu'on utilise pour créer un WeatherModel "à la main"
  /// (par exemple dans des tests).
  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.description,
    required this.iconCode,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  // -------------------- FACTORY CONSTRUCTOR : fromJson --------------------

  /// "factory" signifie que ce constructeur ne crée pas TOUJOURS une nouvelle
  /// instance directement comme le ferait un constructeur classique : il peut
  /// contenir de la logique avant de retourner l'objet (ici : du parsing JSON).
  ///
  /// Ce constructeur prend en entrée un Map<String, dynamic>, c'est-à-dire
  /// la réponse JSON de l'API déjà décodée par jsonDecode().
  ///
  /// Exemple de json reçu (simplifié) :
  /// {
  ///   "name": "Paris",
  ///   "sys": { "country": "FR", "sunrise": 1712556000, "sunset": 1712601600 },
  ///   "main": { "temp": 17.2, "feels_like": 16.0, "temp_min": 15.0,
  ///             "temp_max": 18.0, "humidity": 50, "pressure": 1023 },
  ///   "wind": { "speed": 2.1, "deg": 40 },
  ///   "weather": [ { "description": "ciel dégagé", "icon": "01d" } ],
  ///   "visibility": 10000
  /// }
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    // Étape 1 : on extrait les sous-objets JSON imbriqués dans des variables
    // locales pour rendre le code plus lisible juste en dessous.
    // "as Map<String, dynamic>" force Dart à considérer cette valeur comme
    // un dictionnaire (sinon elle est typée "dynamic", trop permissif).
    final Map<String, dynamic> main = json['main'] as Map<String, dynamic>;
    final Map<String, dynamic> sys = json['sys'] as Map<String, dynamic>;
    final Map<String, dynamic> wind = json['wind'] as Map<String, dynamic>;

    // Le champ "weather" est un TABLEAU JSON (liste), même s'il ne contient
    // généralement qu'un seul élément. On récupère donc le premier élément [0].
    final Map<String, dynamic> weather =
        (json['weather'] as List)[0] as Map<String, dynamic>;

    // Étape 2 : on construit et on retourne l'objet WeatherModel final.
    return WeatherModel(
      // Champ JSON racine "name" -> cityName.
      // Le "?? ''" signifie : si la valeur est null, on met une chaîne vide
      // par sécurité (évite un crash si l'API renvoie un champ manquant).
      cityName: json['name'] ?? '',

      // Champ imbriqué sys.country
      country: sys['country'] ?? '',

      // CONSEIL DU PDF : les nombres JSON peuvent arriver en int OU en double
      // selon les cas (ex: 17 vs 17.2). Pour éviter un crash de type,
      // on caste TOUJOURS en "num" d'abord, puis on convertit en double
      // avec .toDouble(). C'est le pattern de cast sûr recommandé.
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),

      // Ici, l'API renvoie déjà des entiers pour humidity/pressure,
      // mais on caste quand même en "num" puis ".toInt()" par sécurité.
      humidity: (main['humidity'] as num).toInt(),
      pressure: (main['pressure'] as num).toInt(),

      windSpeed: (wind['speed'] as num).toDouble(),
      windDegree: (wind['deg'] as num).toInt(),

      description: weather['description'] ?? '',
      iconCode: weather['icon'] ?? '01d',

      visibility: (json['visibility'] as num?)?.toInt() ?? 0,

      // CONSEIL DU PDF : sunrise/sunset sont des timestamps Unix EN SECONDES.
      // DateTime.fromMillisecondsSinceEpoch() attend des MILLISECONDES.
      // On multiplie donc par 1000 pour faire la conversion correctement.
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (sys['sunrise'] as num).toInt() * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (sys['sunset'] as num).toInt() * 1000,
      ),
    );
  }
}
