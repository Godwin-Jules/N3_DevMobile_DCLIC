// ============================================================================
// FICHIER : weather_widgets.dart
// COUCHE  : Widgets (composants graphiques réutilisables)
// RÔLE    : Factoriser les morceaux d'interface qui se répètent ou qui
//           méritent d'être isolés pour garder weather_view.dart lisible.
//           Chaque widget ici est INDÉPENDANT : il reçoit ses données en
//           paramètres et ne connaît rien du Contrôleur ni du Service.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ============================================================================
// WIDGET 1 : WeatherDetailCard
// ============================================================================
// Petite carte affichant une icône + un libellé + une valeur.
// Utilisée 4 fois dans la grille de détails (humidité, vent, pression, visibilité).
// "StatelessWidget" car cette carte n'a pas d'état interne : elle affiche
// simplement les valeurs qu'on lui donne, sans jamais changer toute seule.
class WeatherDetailCard extends StatelessWidget {
  // Icône à afficher en haut de la carte (ex: Icons.water_drop pour l'humidité)
  final IconData icon;

  // Libellé descriptif, ex: "Humidité"
  final String label;

  // Valeur déjà formatée en texte, ex: "50%"
  final String value;

  // Couleur de l'icône (permet de varier visuellement chaque carte)
  final Color iconColor;

  // Constructeur : "required" signifie que ces 4 paramètres sont obligatoires
  // à chaque utilisation du widget (pas de valeur par défaut ici).
  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Padding interne : espace entre le bord de la carte et son contenu.
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Fond blanc semi-transparent : laisse transparaître le dégradé
        // de fond de l'écran derrière la carte (effet "glassmorphism").
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // L'icône, colorée selon le paramètre reçu.
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 8),
          // La valeur en grand et en gras (information principale de la carte).
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          // Le libellé en plus petit et plus discret (information secondaire).
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WIDGET 2 : WeatherSearchBar
// ============================================================================
// Barre de recherche avec champ de texte + bouton "Obtenir la météo".
// "StatefulWidget" car ce widget gère un petit état interne UI
// (par exemple le fait d'afficher ou non le bouton "effacer" la croix X).
class WeatherSearchBar extends StatefulWidget {
  // Le TextEditingController est créé et géré PAR LA VUE PARENTE
  // (weather_view.dart), puis passé ici en paramètre. Cela permet à la Vue
  // parente de lire/modifier le texte saisi même depuis l'extérieur du widget.
  final TextEditingController controller;

  // Callback (fonction) appelée quand l'utilisateur déclenche une recherche
  // (clic sur le bouton ou validation au clavier). Elle reçoit le nom de
  // la ville saisie en paramètre.
  final void Function(String cityName) onSearch;

  // Liste des suggestions (historique des villes) à afficher sous forme
  // de "chips" cliquables sous le champ de texte.
  final List<String> suggestions;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.suggestions,
  });

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- LE CHAMP DE TEXTE ----------------
        TextField(
          // On relie le champ au controller reçu en paramètre : cela permet
          // de lire la valeur saisie (controller.text) depuis l'extérieur.
          controller: widget.controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Entrez le nom d\'une ville...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            // Bouton "croix" pour vider le champ rapidement, affiché
            // seulement si le champ contient du texte.
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: () {
                      // setState() redessine ce widget pour faire
                      // disparaître la croix après avoir vidé le champ.
                      setState(() => widget.controller.clear());
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          // "onChanged" se déclenche à chaque frappe clavier : on appelle
          // setState() uniquement pour rafraîchir l'affichage de la croix X.
          onChanged: (_) => setState(() {}),
          // "onSubmitted" se déclenche quand l'utilisateur appuie sur
          // "Entrée"/"Rechercher" sur le clavier virtuel : lance directement
          // la recherche sans avoir besoin de cliquer sur le bouton.
          onSubmitted: (value) => widget.onSearch(value),
        ),

        // ---------------- LES CHIPS D'HISTORIQUE ----------------
        // On affiche cette section uniquement si l'historique n'est pas vide.
        if (widget.suggestions.isNotEmpty) ...[
          const SizedBox(height: 10),
          // Wrap permet aux chips de passer à la ligne automatiquement
          // s'il n'y a pas assez de place horizontalement.
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: widget.suggestions.map((ville) {
              // NOTE PÉDAGOGIQUE : on n'utilise PAS le widget ActionChip de
              // Material ici. Avec Material 3 (useMaterial3: true), ActionChip
              // applique automatiquement une couleur de fond et un style de
              // texte issus du thème global (souvent blanc sur blanc sur les
              // dégradés clairs), qui écrasent parfois backgroundColor et
              // labelStyle. On construit donc un "chip" maison avec Material +
              // InkWell, ce qui nous donne un contrôle total et garanti sur
              // CHAQUE couleur affichée, sans dépendre du thème ambiant.
              return Material(
                // "type: MaterialType.transparency" : ce Material ne dessine
                // rien lui-même (pas de couleur de fond imposée par défaut),
                // il sert uniquement de support pour l'effet d'encre (InkWell).
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  // Au clic sur un chip, on relance une recherche pour
                  // cette ville précise.
                  onTap: () => widget.onSearch(ville),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      // Fond explicitement blanc semi-transparent : visible
                      // sur n'importe quel dégradé coloré de fond.
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      ville,
                      // Couleur de texte forcée en blanc : ne dépend plus
                      // du thème Material 3 ambiant.
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// WIDGET 3 : WeatherInitialWidget
// ============================================================================
// Affiché au tout premier lancement de l'app, avant toute recherche.
// "Aucun" paramètre requis comme indiqué dans le PDF : ce widget est
// totalement statique, il n'a besoin d'aucune donnée extérieure.
class WeatherInitialWidget extends StatelessWidget {
  const WeatherInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône "globe" géante, légèrement transparente.
              Icon(
                    Icons.public,
                    size: 100,
                    color: Colors.white.withValues(alpha: 0.7),
                  )
                  // flutter_animate : fait flotter doucement l'icône de haut
                  // en bas, en boucle infinie, pour donner vie à l'écran d'accueil.
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .moveY(
                    begin: -8,
                    end: 8,
                    duration: 2000.ms,
                    curve: Curves.easeInOut,
                  ),

              const SizedBox(height: 24),
              const Text(
                'Recherchez une ville',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'pour obtenir la météo en temps réel',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        )
        // Fondu d'apparition global du widget au moment où il s'affiche.
        .animate()
        .fadeIn(duration: 600.ms);
  }
}

// ============================================================================
// WIDGET 4 : WeatherLoadingWidget
// ============================================================================
// Affiché pendant qu'une requête HTTP est en cours (état "loading").
class WeatherLoadingWidget extends StatelessWidget {
  const WeatherLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Roue de chargement standard de Flutter, en blanc pour rester
          // visible sur le dégradé de fond coloré.
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Recherche en cours...',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// WIDGET 5 : WeatherErrorWidget
// ============================================================================
// Affiché quand une erreur est survenue (état "error").
class WeatherErrorWidget extends StatelessWidget {
  // Le message d'erreur à afficher (vient de controller.errorMessage).
  final String message;

  // Callback appelée quand l'utilisateur clique sur "Réessayer".
  // "VoidCallback" est un raccourci de type pour "void Function()".
  final VoidCallback onRetry;

  const WeatherErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 24),
                // Bouton "Réessayer" qui redéclenche la dernière recherche.
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .shake(
          hz: 2,
          curve: Curves.easeInOut,
        ); // léger tremblement pour signaler l'erreur
  }
}
