import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/populartimes/cache/PopularityPointsCache.dart';
import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';

void main() {
  PopularityPointsCache cache;
  setUp(() async {
    cache = new PopularityPointsCache();
  });

  test('cache should be empty when created', () {
    expect(cache.points.keys.length, 0);
    expect(cache.zoomLevels.keys.length, 0);
    expect(cache.popularities.keys.length, 0);
  });

  test('should store all settings', () {
    final int placeCurrentPopularity = 78;
    final double zoomLevel = 15;
    final String id = "Ch_zdkjzodzkda";
    final PlacesAPIResult place = PlacesAPIResult(
        placeId: id, location: LatLng(55.18, 3.48));

    Map<String, WeightedLatLng> points =
      cache.getPoints(place, placeCurrentPopularity, zoomLevel);
    expect(points.keys.length, isNonNegative);

    expect(cache.zoomLevels[id], zoomLevel);
    expect(cache.popularities[id], placeCurrentPopularity);
    expect(cache.points[id], points);
  });
}