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

  test("should return same points if zoom and popularity levels didn't change", () {
    final int placeCurrentPopularity = 78;
    final double zoomLevel = 15;
    final String id = "Ch_zdkjzodzkda";
    final PlacesAPIResult place = PlacesAPIResult(
        placeId: id, location: LatLng(55.18, 3.48));

    Map<String, WeightedLatLng>
      points = cache.getPoints(place, placeCurrentPopularity, zoomLevel),
      points2 = cache.getPoints(place, placeCurrentPopularity, zoomLevel);

    expect(points, points2);
  });

  test("should regenerate popularity points if zoom level has changed", () {
    final int placeCurrentPopularity = 78;
    final double oldZoomLevel = 15, newZoomLevel = 21;
    final String id = "Ch_zdkjzodzkda";
    final PlacesAPIResult place = PlacesAPIResult(
        placeId: id, location: LatLng(55.18, 3.48));

    Map<String, WeightedLatLng> points =
      cache.getPoints(place, placeCurrentPopularity, oldZoomLevel);
    expect(cache.zoomLevels[id], oldZoomLevel);
    expect(cache.popularities[id], placeCurrentPopularity);
    expect(cache.points[id], points);

    Map<String, WeightedLatLng> newPoints =
      cache.getPoints(place, placeCurrentPopularity, newZoomLevel);
    expect(cache.zoomLevels[id], newZoomLevel);
    expect(cache.popularities[id], placeCurrentPopularity);
    expect(cache.points[id], newPoints);

    expect(points.length, newPoints.length);
    expect(points, isNot(equals(newPoints)));
  });
}