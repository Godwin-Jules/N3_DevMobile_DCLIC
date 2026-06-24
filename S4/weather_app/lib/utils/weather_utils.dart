import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  WeatherUtils._();

  static String formatTemp(double temp) {
    return '${temp.round()}°C';
  }

  static String formatTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  static String formatDate(DateTime dt) {
    return DateFormat.yMMMMEEEEd('fr').format(dt);
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() + text.substring(1);
  }

  static String getWeatherEmoji(String code) {
    if (code.startsWith('01')) return '☀️';
    if (code.startsWith('02')) return '🌤️';
    if (code.startsWith('03')) return '☁️';
    if (code.startsWith('04')) return '☁️';
    if (code.startsWith('09')) return '🌧️';
    if (code.startsWith('10')) return '🌦️';
    if (code.startsWith('11')) return '⛈️';
    return '🌍';
  }

  static List<Color> getGradientColors(String iconCode) {
    if (iconCode.startsWith('01')) {
      return [Colors.lightBlue, Colors.blue];
    }

    if (iconCode.startsWith('10')) {
      return [Colors.indigo, Colors.blueGrey];
    }

    return [Colors.blueGrey, Colors.grey];
  }
}
