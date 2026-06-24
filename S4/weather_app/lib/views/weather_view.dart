import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/widgets/weather_detail_card.dart';
import 'package:weather_app/widgets/weather_error.dart';
import 'package:weather_app/widgets/weather_loading.dart';
import 'package:weather_app/widgets/weather_initial.dart';

import '../controllers/weather_controller.dart';
import '../utils/weather_utils.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with SingleTickerProviderStateMixin {
  final TextEditingController cityController = TextEditingController();

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    fadeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherController>(
      builder: (context, controller, child) {
        final colors = controller.weather != null
            ? WeatherUtils.getGradientColors(controller.weather!.iconCode)
            : [Colors.blue, Colors.indigo];

        return Scaffold(
          body: AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Nom de la ville",
                        prefixIcon: Icon(Icons.location_city_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 5,
                      children: controller.searchHistory
                          .map(
                            (city) => ActionChip(
                              label: Text(city),
                              onPressed: () {
                                cityController.text = city;
                                controller.fetchWeather(city);
                              },
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.cloud),
                        label: const Text("Obtenir la météo"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          if (cityController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Veuillez saisir une ville"),
                              ),
                            );
                            return;
                          }

                          fadeController.forward(from: 0);

                          await controller.fetchWeather(
                            cityController.text.trim(),
                          );

                          if (controller.status == WeatherStatus.success) {
                            fadeController.forward(from: 0);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(child: _buildContent(controller)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(WeatherController controller) {
    switch (controller.status) {
      case WeatherStatus.initial:
        return const WeatherInitialWidget();

      case WeatherStatus.loading:
        return const WeatherLoadingWidget();

      case WeatherStatus.error:
        return FadeTransition(
          opacity: fadeAnimation,
          child: WeatherErrorWidget(
            key: ValueKey(controller.errorMessage),
            message: controller.errorMessage,
            onRetry: () async {
              if (cityController.text.isNotEmpty) {
                await controller.fetchWeather(cityController.text.trim());
              }

              fadeController.forward(from: 0);
            },
          ),
        );

      case WeatherStatus.success:
        final weather = controller.weather!;

        return FadeTransition(
          opacity: fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "${weather.cityName}, ${weather.country}",
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  WeatherUtils.formatDate(DateTime.now()),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),

                Text(
                  WeatherUtils.getWeatherEmoji(weather.iconCode),
                  style: const TextStyle(fontSize: 80),
                ),

                Text(
                  WeatherUtils.formatTemp(weather.temperature),
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  WeatherUtils.capitalize(weather.description),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),

                const SizedBox(height: 20),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: [
                    WeatherDetailCardWidget(
                      icon: Icons.water_drop,
                      label: "Humidité",
                      value: "${weather.humidity} %",
                      iconColor: Colors.blue,
                    ),

                    WeatherDetailCardWidget(
                      icon: Icons.air,
                      label: "Vent",
                      value: "${weather.windSpeed} m/s",
                      iconColor: Colors.green,
                    ),

                    WeatherDetailCardWidget(
                      icon: Icons.speed,
                      label: "Pression",
                      value: "${weather.pressure} hPa",
                      iconColor: Colors.orange,
                    ),

                    WeatherDetailCardWidget(
                      icon: Icons.visibility,
                      label: "Visibilité",
                      value:
                          "${(weather.visibility / 1000).toStringAsFixed(1)} km",
                      iconColor: Colors.purple,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.wb_sunny),
                    title: Text(
                      "Lever : ${WeatherUtils.formatTime(weather.sunrise)}",
                    ),
                    subtitle: Text(
                      "Coucher : ${WeatherUtils.formatTime(weather.sunset)}",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }
}
