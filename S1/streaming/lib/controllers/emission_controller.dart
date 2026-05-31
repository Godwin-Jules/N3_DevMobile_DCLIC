import 'package:streaming/data/mock_data.dart';

import '../models/emission.dart';
import '../models/diffusion.dart';

class EmissionController {
  final List<Emission> _emissions = mockEmissions;

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
