import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';

// TODO provide an HTTPClient implementation (http calls are not allowed in tests)
void main() {
  group('Popular times parser tests', () {
    test('Checking popular times of a place that have some', () async {
      Favorite placeWithStats = new Favorite(
          name: "E.Leclerc Paris 19", address: "191 Boulevard Macdonald, 75019 Paris, France");
      var stats = await Parser.getPopularTimes(placeWithStats);

      expect(stats.stats.length, 18);
      expect(stats.stats[0].times[0], 6);
      expect(stats.stats[17].times[0], 23);
    });

    test('Checking popular times of a place that does not have some', () async {
      Favorite placeWithoutStats = new Favorite(
          name: "Lilliad", address: "2, Avenue Jean Perrin, 59650 Villeneuve-d'Ascq, France"
      );
      var result = await Parser.getPopularTimes(placeWithoutStats);
      expect(result.hasData, false);
    });
  });
}
