import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parserCache.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';
import 'package:test/test.dart';

void main() {
  ParserCache cache;
  Favorite place = new Favorite(id: 'dddzzdzkDKDdkzpokzdz', name: 'Test place');
  setUp(() async {
    cache = new ParserCache();
  });

  test('cache should be empty when created', () {
    expect(cache.statsCache.keys.length, 0);
    expect(cache.timesCache.keys.length, 0);
  });

  test('should not contain key when created', () {
    expect(cache.hasStatsForPlace(place), false);
    expect(cache.getStatsFromPlace(place), null);
  });

  test('should properly store stats', () {
    expect(cache.hasStatsForPlace(place), false);

    PopularTimes stats = PopularTimes(currentPopularity: 42, hasData: false);
    cache.storeStatsForPlace(place, stats);

    expect(cache.statsCache.keys.length, 1);
    expect(cache.timesCache.keys.length, 1);

    expect(cache.hasStatsForPlace(place), true);
    expect(cache.getStatsFromPlace(place), stats);
  });

  test('should overwrite stats', () {
    expect(cache.hasStatsForPlace(place), false);

    PopularTimes stats = PopularTimes(currentPopularity: 42, hasData: false);
    cache.storeStatsForPlace(place, stats);
    cache.storeStatsForPlace(place, PopularTimes(currentPopularity: 44, hasData: false));

    expect(cache.hasStatsForPlace(place), true);
    expect(cache.getStatsFromPlace(place).currentPopularity, 44);
  });

  test('should clean cache', () {
    cache.storeStatsForPlace(Favorite(id: 'hello'), PopularTimes(currentPopularity: 12));
    cache.storeStatsForPlace(Favorite(id: 'hola'), PopularTimes(currentPopularity: 24));
    expect(cache.statsCache.keys.length, 2);

    cache.clear();
    expect(cache.statsCache.keys.length, 0);
    expect(cache.timesCache.keys.length, 0);
  });
}