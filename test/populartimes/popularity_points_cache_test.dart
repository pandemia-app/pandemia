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

  test("should regenerate popularity points if popularity level has changed", () {
    final int oldPop = 78, newPop = 42;
    final double zoomLevel = 15;
    final String id = "Ch_zdkjzodzkda";
    final PlacesAPIResult place = PlacesAPIResult(
        placeId: id, location: LatLng(55.18, 3.48));

    Map<String, WeightedLatLng> points =
    cache.getPoints(place, oldPop, zoomLevel);
    expect(cache.zoomLevels[id], zoomLevel);
    expect(cache.popularities[id], oldPop);
    expect(cache.points[id], points);

    Map<String, WeightedLatLng> newPoints =
    cache.getPoints(place, newPop, zoomLevel);
    expect(cache.zoomLevels[id], zoomLevel);
    expect(cache.popularities[id], newPop);
    expect(cache.points[id], newPoints);

    expect(points.length, isNot(equals(newPoints.length)));
    expect(points, isNot(equals(newPoints)));
  });

  test("should store several places' points", () {
    final PlacesAPIResult
      place = PlacesAPIResult(placeId: "a", location: LatLng(55.18, 3.48)),
      place1 = PlacesAPIResult(placeId: "b", location: LatLng(42.54, 3.57)),
      place2 = PlacesAPIResult(placeId: "c", location: LatLng(42.54, 3.57));

    var placePoints = cache.getPoints(place, 15, 42);
    var place1Points = cache.getPoints(place1, 15, 42);
    var place2Points = cache.getPoints(place2, 15, 42);

    expect(cache.points.keys.length, 3);
    expect(cache.zoomLevels.keys.length, 3);
    expect(cache.popularities.keys.length, 3);

    expect(placePoints, isNot(equals(place1Points)));
    expect(placePoints, isNot(equals(place2Points)));
    expect(place1Points, isNot(equals(place2Points)));
  });
}