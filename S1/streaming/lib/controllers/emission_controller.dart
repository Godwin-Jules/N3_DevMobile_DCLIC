import 'package:streaming/data/mock_data.dart';

import '../models/emission.dart';
import '../models/diffusion.dart';

class EmissionController {
  final List<Emission> _emissions = mockEmissions;
  // final List<Emission> _emissions = [
  //   const Emission(
  //     id: 1,
  //     nom: 'Morning News',
  //     chaine: 'Radio 4',
  //     image: 'assets/images/news.png',
  //   ),
  //   const Emission(
  //     id: 2,
  //     nom: 'Music Time',
  //     chaine: 'FM Music',
  //     image: 'assets/images/music.avif',
  //   ),
  //   const Emission(
  //     id: 3,
  //     nom: 'Sport Live',
  //     chaine: 'Sport Radio',
  //     image: 'assets/images/sport.avif',
  //   ),
  //   const Emission(
  //     id: 4,
  //     nom: 'Tech Talk',
  //     chaine: 'Digital FM',
  //     image: 'assets/images/tech.avif',
  //   ),
  //   const Emission(
  //     id: 5,
  //     nom: 'Culture Plus',
  //     chaine: 'Culture TV',
  //     image: 'assets/images/culture.jpg',
  //   ),
  //   const Emission(
  //     id: 6,
  //     nom: 'Business Show',
  //     chaine: 'Finance Radio',
  //     image: 'assets/images/business.webp',
  //   ),
  // ];

  List<Emission> getEmissions() {
    return _emissions;
  }

  Emission onEmissionSelected(Emission emission) {
    return emission;
  }

  List<Diffusion> getDiffusions() {
    return [
      Diffusion(
        titre: "Episode 01",
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Diffusion(
        titre: "Episode 02",
        date: DateTime.now().subtract(const Duration(days: 4)),
      ),
      Diffusion(
        titre: "Episode 03",
        date: DateTime.now().subtract(const Duration(days: 8)),
      ),
      Diffusion(
        titre: "Episode 04",
        date: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Diffusion(
        titre: "Episode 05",
        date: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }
}
