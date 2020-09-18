import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/populartimes/cache/PopularityPointsCache.dart';

void main() {
  PopularityPointsCache cache;setUp(() async {
    cache = new PopularityPointsCache();
  });

  test('cache should be empty when created', () {
    expect(cache.points.keys.length, 0);
    expect(cache.zoomLevels.keys.length, 0);
    expect(cache.popularities.keys.length, 0);
  });
}