class WeatherModel {
  final String cityName;
  final String country;

  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;

  final int humidity;
  final int pressure;

  final double windSpeed;
  final int windDegree;

  final String description;
  final String iconCode;

  final int visibility;

  final DateTime sunrise;
  final DateTime sunset;

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

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> main = json['main'] as Map<String, dynamic>;
    final Map<String, dynamic> sys = json['sys'] as Map<String, dynamic>;
    final Map<String, dynamic> wind = json['wind'] as Map<String, dynamic>;

    return WeatherModel(
      cityName: json['name'],
      country: sys['country'],

      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      tempMin: (main['temp_min'] as num).toDouble(),
      tempMax: (main['temp_max'] as num).toDouble(),

      humidity: main['humidity'],
      pressure: main['pressure'],

      windSpeed: (wind['speed'] as num).toDouble(),
      windDegree: wind['deg'] ?? 0,

      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],

      visibility: json['visibility'] ?? 0,

      sunrise: DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000),

      sunset: DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000),
    );
  }
}
