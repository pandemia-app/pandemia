import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';

// TODO provide an HTTPClient implementation (http calls are not allowed in tests)
void main() {
  testWidgets('Testing popular times parser', (WidgetTester tester) async {
    Favorite placeWithStats = new Favorite(
        name: "E.Leclerc Paris 19", address: "191 Boulevard Macdonald, 75019 Paris, France");
    Favorite placeWithoutStats = new Favorite(
      name: "Lilliad", address: "2, Avenue Jean Perrin, 59650 Villeneuve-d'Ascq, France"
    );

    print('Checking popular times of a place that have some');
    var stats = await Parser.getPopularTimes(placeWithStats);
    expect(stats.length, 18);
    expect(stats[0][0], 6);
    expect(stats[17][0], 23);

    print('Checking popular times of a place that does not have some');
    var result = await Parser.getPopularTimes(placeWithoutStats);
    expect(result, -1);
  });
}
