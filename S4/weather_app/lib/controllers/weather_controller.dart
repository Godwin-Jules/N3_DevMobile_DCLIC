import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherController extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _weather;
  String _errorMessage = '';

  final List<String> _searchHistory = [];

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String get errorMessage => _errorMessage;
  List<String> get searchHistory => _searchHistory;

  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasData => _weather != null;
  bool get hasError => _status == WeatherStatus.error;

  Future<void> fetchWeather(String city) async {
    _status = WeatherStatus.loading;
    notifyListeners();

    try {
      _weather = await _service.getWeather(city);

      _searchHistory.remove(city);
      _searchHistory.insert(0, city);

      if (_searchHistory.length > 5) {
        _searchHistory.removeLast();
      }

      _status = WeatherStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = WeatherStatus.error;
    }

    notifyListeners();
  }
}
