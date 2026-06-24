// ============================================================================
// FICHIER : weather_view.dart
// COUCHE  : Vue (V de MVC)
// RÔLE    : Afficher l'interface utilisateur et réagir aux actions de
//           l'utilisateur (saisie, clics). Cette classe NE FAIT JAMAIS
//           d'appel HTTP elle-même : elle appelle uniquement les méthodes
//           du Contrôleur (via Provider/Consumer).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/weather_controller.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_widgets.dart';

// "StatefulWidget" car cette Vue a besoin de gérer un état purement visuel :
// le TextEditingController du champ de recherche et l'AnimationController
// du fondu d'apparition. Ce ne sont PAS des données métier (elles ne vont
// pas dans le Contrôleur), donc elles restent ici, dans la Vue.
class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

// "with TickerProviderStateMixin" : nécessaire pour pouvoir créer un
// AnimationController. Le "Ticker" est ce qui rythme les animations,
// image par image, en synchronisation avec l'écran.
class _WeatherViewState extends State<WeatherView>
    with TickerProviderStateMixin {
  // Contrôleur du champ de texte : conserve le texte saisi par l'utilisateur
  // et permet de le lire/modifier/vider depuis le code.
  final TextEditingController _searchController = TextEditingController();

  // Contrôleur de l'animation de fondu (FadeTransition) appliquée à la
  // zone de données météo quand elles apparaissent après une recherche réussie.
  late AnimationController _fadeController;

  // L'animation elle-même : une valeur qui évolue de 0.0 (invisible)
  // à 1.0 (totalement visible) au fil du temps.
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // On initialise l'AnimationController : "vsync: this" relie l'animation
    // au rythme de rafraîchissement de l'écran (grâce au Mixin ci-dessus).
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // CurvedAnimation applique une "courbe" de progression à l'animation
    // (ici easeIn : démarre lentement puis accélère) plutôt qu'une
    // progression linéaire, ce qui paraît plus naturel à l'œil.
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    // CRUCIAL : on libère les ressources des contrôleurs quand le widget
    // est détruit, pour éviter les fuites de mémoire (memory leaks).
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  /// Méthode appelée quand l'utilisateur lance une recherche (bouton,
  /// validation clavier, ou clic sur un chip d'historique).
  void _handleSearch(String cityName) {
    if (cityName.trim().isEmpty) return;

    // On synchronise le champ de texte avec la ville recherchée
    // (utile quand on clique sur un chip d'historique : le texte du champ
    // se met à jour pour refléter la ville cliquée).
    _searchController.text = cityName;

    // On récupère le Contrôleur SANS s'abonner aux changements ici
    // ("listen: false") car on ne fait qu'appeler une méthode, on n'a pas
    // besoin que ce widget précis se redessine à cet endroit du code.
    final controller = context.read<WeatherController>();

    // On lance la requête. Comme fetchWeather() est asynchrone, on utilise
    // ".then()" pour exécuter l'animation de fondu UNE FOIS la réponse reçue.
    controller.fetchWeather(cityName).then((_) {
      // On vérifie "mounted" : le widget est-il toujours affiché à l'écran ?
      // (sécurité : évite un crash si l'utilisateur a changé d'écran entre
      // temps, pendant que la requête réseau était encore en cours).
      if (mounted && controller.hasData) {
        // On relance l'animation de fondu depuis le début (from: 0)
        // à chaque nouvelle recherche réussie, comme demandé dans le PDF.
        _fadeController.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // "Consumer<WeatherController>" est le widget fourni par Provider qui
    // ÉCOUTE le Contrôleur : à chaque notifyListeners() appelé dans le
    // Contrôleur, le "builder" ci-dessous est automatiquement ré-exécuté,
    // ce qui redessine l'interface avec les nouvelles données/état.
    return Consumer<WeatherController>(
      builder: (context, controller, child) {
        // On détermine les couleurs du dégradé de fond selon la météo
        // actuelle (ou un dégradé bleu par défaut si pas encore de données).
        final List<Color> gradientColors = controller.hasData
            ? WeatherUtils.getGradientColors(controller.weather!.iconCode)
            : const [Color(0xFF4FACFE), Color(0xFF00C6FB)];

        return Scaffold(
          body: AnimatedContainer(
            // AnimatedContainer fait la transition progressive entre
            // l'ancien et le nouveau dégradé de couleurs (au lieu d'un
            // changement brutal), comme demandé dans le PDF.
            duration: const Duration(milliseconds: 800),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            // SafeArea évite que le contenu passe sous l'encoche/la barre
            // de statut du téléphone.
            child: SafeArea(
              child: Column(
                children: [
                  // ---------------- BARRE DU HAUT ----------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Application Météo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        // Bouton "rafraîchir" : relance la dernière
                        // recherche si des données sont déjà affichées.
                        if (controller.hasData)
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                _handleSearch(controller.weather!.cityName),
                          ),
                      ],
                    ),
                  ),

                  // ---------------- BARRE DE RECHERCHE ----------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      children: [
                        WeatherSearchBar(
                          controller: _searchController,
                          onSearch: _handleSearch,
                          suggestions: controller.searchHistory,
                        ),
                        const SizedBox(height: 14),
                        // Bouton principal "Obtenir la météo"
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: controller.isLoading
                                ? null // désactivé pendant le chargement
                                : () => _handleSearch(_searchController.text),
                            icon: const Icon(Icons.search),
                            label: const Text('Obtenir la météo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.25),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------------- ZONE CENTRALE DYNAMIQUE ----------------
                  // "Expanded" + "SingleChildScrollView" permet à cette zone
                  // d'occuper tout l'espace restant ET d'être scrollable
                  // si le contenu (données météo) dépasse la hauteur d'écran.
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildCentralContent(controller),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Choisit QUEL widget afficher dans la zone centrale, en fonction
  /// de l'état courant du Contrôleur (WeatherStatus). C'est le cœur de la
  /// logique de "Vue réactive" : un seul état affiché à la fois.
  Widget _buildCentralContent(WeatherController controller) {
    switch (controller.status) {
      case WeatherStatus.initial:
        return const WeatherInitialWidget();

      case WeatherStatus.loading:
        return const WeatherLoadingWidget();

      case WeatherStatus.error:
        return WeatherErrorWidget(
          message: controller.errorMessage,
          // Le bouton "Réessayer" relance la recherche avec le texte
          // actuellement saisi dans le champ.
          onRetry: () => _handleSearch(_searchController.text),
        );

      case WeatherStatus.success:
        // On sait que controller.weather n'est pas null ici grâce au
        // getter hasData vérifié plus haut, mais Dart veut quand même
        // qu'on confirme avec "!" (non-null assertion).
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _WeatherDataView(weather: controller.weather!),
        );
    }
  }
}

// ============================================================================
// WIDGET PRIVÉ : _WeatherDataView
// ============================================================================
// Affiche TOUTES les informations météo une fois les données reçues.
// Préfixé par "_" : ce widget n'est utilisé QUE dans ce fichier, il n'a
// pas besoin d'être visible/réutilisable depuis l'extérieur.
class _WeatherDataView extends StatelessWidget {
  final WeatherModel weather;

  const _WeatherDataView({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // -------------------- SECTION PRINCIPALE --------------------
        Column(
          children: [
            // Nom de la ville + pays, avec icône de localisation.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${weather.cityName}, ${weather.country}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Date/heure de mise à jour, formatée en français.
            Text(
              WeatherUtils.formatDate(DateTime.now()),
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // Emoji météo géant + température en grand.
            Text(
              WeatherUtils.getWeatherEmoji(weather.iconCode),
              style: const TextStyle(fontSize: 72),
            ),
            Text(
              WeatherUtils.formatTemp(weather.temperature),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 56,
                fontWeight: FontWeight.w300, // police fine pour un look moderne
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Ressenti ${WeatherUtils.formatTemp(weather.feelsLike)}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),

            // Badge avec la description textuelle (ex: "Ciel dégagé").
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                WeatherUtils.capitalize(weather.description),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),

            // Min / Max du jour.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: Colors.lightBlue[100],
                  size: 16,
                ),
                Text(
                  ' Min ${WeatherUtils.formatTemp(weather.tempMin)}  ',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Icon(Icons.arrow_upward, color: Colors.orange[100], size: 16),
                Text(
                  ' Max ${WeatherUtils.formatTemp(weather.tempMax)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 28),

        // -------------------- GRILLE DE DÉTAILS (2 colonnes) --------------------
        // GridView.count crée automatiquement une grille à 2 colonnes,
        // comme recommandé dans le PDF (crossAxisCount: 2).
        GridView.count(
          crossAxisCount: 2,
          // "shrinkWrap" + "physics: NeverScrollableScrollPhysics()" :
          // la grille prend uniquement la place nécessaire à son contenu
          // et ne crée pas SON PROPRE scroll (on est déjà dans un
          // SingleChildScrollView au niveau de la Vue parente).
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            // Carte Humidité
            WeatherDetailCard(
              icon: Icons.water_drop,
              label: 'Humidité',
              value: '${weather.humidity}%',
              iconColor: Colors.lightBlueAccent,
            ),
            // Carte Vent (vitesse + direction cardinale)
            WeatherDetailCard(
              icon: Icons.air,
              label: 'Vent',
              value:
                  '${weather.windSpeed.toStringAsFixed(1)} m/s ${WeatherUtils.degreesToCardinal(weather.windDegree)}',
              iconColor: Colors.tealAccent,
            ),
            // Carte Pression
            WeatherDetailCard(
              icon: Icons.speed,
              label: 'Pression',
              value: '${weather.pressure} hPa',
              iconColor: Colors.purpleAccent,
            ),
            // Carte Visibilité (conversion mètres → kilomètres)
            WeatherDetailCard(
              icon: Icons.visibility,
              label: 'Visibilité',
              value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
              iconColor: Colors.amberAccent,
            ),
          ],
        ),

        const SizedBox(height: 20),

        // -------------------- SECTION LEVER / COUCHER DE SOLEIL --------------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Lever du soleil
              Column(
                children: [
                  const Icon(
                    Icons.wb_twilight,
                    color: Colors.orangeAccent,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    WeatherUtils.formatTime(weather.sunrise),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Lever',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Séparateur vertical
              Container(
                height: 40,
                width: 1,
                color: Colors.white.withOpacity(0.2),
              ),
              // Coucher du soleil
              Column(
                children: [
                  const Icon(
                    Icons.nights_stay,
                    color: Colors.indigoAccent,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    WeatherUtils.formatTime(weather.sunset),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Coucher',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
