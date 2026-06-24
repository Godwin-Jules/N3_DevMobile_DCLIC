// ============================================================================
// FICHIER : main.dart
// RÔLE    : Point d'entrée de l'application. Effectue les initialisations
//           nécessaires AVANT le lancement, puis injecte le Contrôleur dans
//           l'arbre de widgets via Provider pour le rendre accessible
//           à toute l'application (pattern d'injection de dépendance).
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controllers/weather_controller.dart';
import 'views/weather_view.dart';

// "main()" est "async" car on doit ATTENDRE (await) plusieurs opérations
// d'initialisation avant de pouvoir lancer l'application avec runApp().
void main() async {
  // ÉTAPE 1 : indispensable avant tout appel à des plugins natifs
  // (ici : SystemChrome) lorsque l'app n'a pas encore démarré son moteur
  // Flutter complet. C'est une ligne "rituelle" à connaître par cœur.
  WidgetsFlutterBinding.ensureInitialized();

  // ÉTAPE 2 : initialise les données de formatage de date pour la locale
  // française ('fr_FR'). Sans cet appel, WeatherUtils.formatDate() (qui
  // utilise DateFormat('EEEE d MMMM yyyy', 'fr_FR')) lèverait une exception
  // au moment de l'exécution.
  await initializeDateFormatting('fr_FR', null);

  // ÉTAPE 3 : on force l'application à rester en orientation PORTRAIT
  // uniquement (on bloque le mode paysage), car l'interface a été pensée
  // pour un affichage vertical de type smartphone.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ÉTAPE 4 : on rend la barre de statut (en haut de l'écran, avec l'heure,
  // la batterie...) transparente, avec des icônes CLAIRES (blanches), pour
  // qu'elle se fonde visuellement dans le dégradé coloré de notre interface.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // icônes blanches (Android)
      statusBarBrightness: Brightness.dark, // fond sombre supposé (iOS)
    ),
  );

  // ÉTAPE 5 : on lance enfin l'application.
  runApp(const MeteoApp());
}

// ============================================================================
// CLASSE RACINE DE L'APPLICATION
// ============================================================================
class MeteoApp extends StatelessWidget {
  const MeteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // "ChangeNotifierProvider" est le widget fourni par le package Provider
    // qui CRÉE une instance du Contrôleur et la rend disponible à TOUS les
    // widgets descendants de l'arbre, sans avoir à la passer manuellement
    // de widget en widget (on évite le "prop drilling").
    return ChangeNotifierProvider(
      // "create" prend une fonction qui retourne une NOUVELLE instance
      // du Contrôleur. Cette instance est créée UNE SEULE FOIS,
      // au démarrage de l'app, puis réutilisée partout.
      create: (context) => WeatherController(),
      child: MaterialApp(
        title: 'Application Météo',
        debugShowCheckedModeBanner: false, // masque le bandeau "DEBUG" rouge
        theme: ThemeData(
          // ColorScheme.fromSeed() génère automatiquement une palette de
          // couleurs harmonieuse à partir d'une seule couleur de référence
          // ("seedColor"). C'est l'approche moderne recommandée par
          // Flutter 3, qui remplace l'ancien "primarySwatch" (obsolète).
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4FACFE),
            brightness: Brightness.light,
          ),
          // Active le nouveau système de design "Material 3" de Flutter 3,
          // qui modernise l'apparence des boutons, champs de texte, etc.
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        // La page d'accueil de l'application est notre Vue principale.
        home: const WeatherView(),
      ),
    );
  }
}
