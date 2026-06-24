import 'package:flutter/material.dart';

class WeatherInitialWidget extends StatelessWidget {
  const WeatherInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentGeometry.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('🌍', style: TextStyle(fontSize: 80)),
          Text(
            "Recherchez une ville",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Text(
//                   WeatherUtils.getWeatherEmoji(weather.iconCode),
//                   style: const TextStyle(fontSize: 80),
//                 ),

//                 Text(
//                   WeatherUtils.formatTemp(weather.temperature),
//                   style: const TextStyle(
//                     fontSize: 50,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
