import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parserCache.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';

void main() {
  ParserCache cache;
  Favorite place = new Favorite(id: 'dddzzdzkDKDdkzpokzdz', name: 'Test place', address: "a");
  Favorite place1 = new Favorite(id: 'dzadgrhhyjgbfgerfg', name: 'Test place 1', address: "a");
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

    PopularTimes stats = PopularTimes(stats: Map(), currentPopularity: 42);
    cache.storeStatsForPlace(place, stats);

    expect(cache.statsCache.keys.length, 1);
    expect(cache.timesCache.keys.length, 1);

    expect(cache.hasStatsForPlace(place), true);
    expect(cache.getStatsFromPlace(place), stats);
  });

  test('should properly store several stats', () {
    expect(cache.hasStatsForPlace(place), false);
    expect(cache.hasStatsForPlace(place1), false);

    PopularTimes
        stats = PopularTimes(stats: Map(), currentPopularity: 42),
        stats1 = PopularTimes(stats: Map(), currentPopularity: 54);
    cache.storeStatsForPlace(place, stats);
    cache.storeStatsForPlace(place1, stats1);

    expect(cache.statsCache.keys.length, 2);
    expect(cache.timesCache.keys.length, 2);
    expect(cache.hasStatsForPlace(place), true);
    expect(cache.getStatsFromPlace(place), stats);
    expect(cache.hasStatsForPlace(place1), true);
    expect(cache.getStatsFromPlace(place1), stats1);
  });

  test('should overwrite stats', () {
    expect(cache.hasStatsForPlace(place), false);

    PopularTimes stats = PopularTimes(stats: Map(), currentPopularity: 42);
    cache.storeStatsForPlace(place, stats);
    cache.storeStatsForPlace(place, PopularTimes(stats: Map(), currentPopularity: 44));

    expect(cache.hasStatsForPlace(place), true);
    expect(cache.getStatsFromPlace(place).currentPopularity, 44);
  });

  test('should clean cache', () {
    cache.storeStatsForPlace(Favorite(id: 'hello', address: "a", name: "n"),
        PopularTimes(stats: Map(), currentPopularity: 12));
    cache.storeStatsForPlace(Favorite(id: 'hola', address: "a", name: "n"),
        PopularTimes(stats: Map(), currentPopularity: 24));
    expect(cache.statsCache.keys.length, 2);

    cache.clear();
    expect(cache.statsCache.keys.length, 0);
    expect(cache.timesCache.keys.length, 0);
  });
}