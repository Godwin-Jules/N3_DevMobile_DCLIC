import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/services/api_config.dart';
import 'package:weather_app/services/weather_exceptions.dart';

import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> getWeather(String city) async {
    try {
      final Uri uri = Uri.parse(
        '${ApiConfig.baseUrl}?q=$city&appid=${ApiConfig.apiKey}&units=metric&lang=fr',
      );

      final response = await http.get(uri);

      switch (response.statusCode) {
        case 200:
          return WeatherModel.fromJson(jsonDecode(response.body));

        case 401:
          throw InvalidApiKeyException();

        case 404:
          throw CityNotFoundException(city);

        case 429:
          throw TooManyRequestsException();

        default:
          throw ServerErrorException(response.statusCode);
      }
    } on WeatherException {
      rethrow;
    } catch (e) {
      throw NetworkException();
    }
  }
}
