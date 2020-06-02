import 'dart:math';
import 'package:latlong/latlong.dart' as latlong;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Is in charge of geolocation-related computation.
class GeoComputer {
  double degree = 6371 * 2 * pi / 360 * 1000; // 1° latitude in meters

  /// Returns central location of a rectangular window determined by
  /// bounds.northeast and bounds.southwest.
  LatLng getBoundsCenterLocation (LatLngBounds bounds) {
    return new LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2
    );
  }

  /// Returns radius of a circle that covers a given rectangular zone.
  /// To avoid choosing a radius which would create a circle with a lot of
  /// off-screen space, this returns maximum value of two distances:
  /// * from screen middle to screen northern location;
  /// * from screen middle to screen eastern location.
  /// This allows the search zone to adapt to all screen resolutions.
  double getSearchRadius (LatLngBounds bounds) {
    LatLng middle = getBoundsCenterLocation(bounds);
    LatLng eastMarker = new LatLng(middle.latitude, bounds.northeast.longitude);
    LatLng northMarker = new LatLng(bounds.northeast.latitude, middle.longitude);

    final latlong.Distance distance = new latlong.Distance();
    final double eastDistance = distance(
        new latlong.LatLng(middle.latitude, middle.longitude),
        new latlong.LatLng(eastMarker.latitude, eastMarker.longitude));
    final double northDistance = distance (
        new latlong.LatLng(middle.latitude, middle.longitude),
        new latlong.LatLng(northMarker.latitude, northMarker.longitude)
    );

    return max (eastDistance, northDistance);
  }

  /// Returns random coordinates [x, y] included in a circle.
  /// See https://stackoverflow.com/a/43202522/11243782 for more details.
  List<double> randomPointInDisk (double maxRadius) {
    Random random = Random.secure();
    double r = maxRadius * random.nextDouble() * 0.5;
    double theta = random.nextDouble() * 2 * pi;
    return [
      r * cos(theta),
      r * sin(theta)
    ];
  }

  /// Generates a list of random points around a place.
  /// The count of generated points for a given place is directly correlated to
  /// its current popularity.
  List<LatLng> createRandomPoints (LatLng center, double radius, int popularity) {
    List<LatLng> points = new List();
    for (int i=0; i<popularity; i++) {
      List<double> randomCoordinates = randomPointInDisk(radius);
      double dx = randomCoordinates.first;
      double dy = randomCoordinates.last;

      points.add(
          new LatLng(
              center.latitude + dy / degree,
              center.longitude + dx / degree));
    }
    return points;
  }

  /// Generates a set of locations situated around a given place.
  /// The popularity of the place is reflected by:
  /// * the count of generated locations;
  /// * the radius of the circle which contains these locations.
  Map<String, WeightedLatLng> generatePopularityPoints (LatLng center, String placeId, int popularity, double zoomLevel) {
    Map<String, WeightedLatLng> pointsCache = <String, WeightedLatLng>{};

    // zoom level can vary from ~9.9 (at minimum zoom) to 21
    // zoom bias varies from 10 to 1
    // the smaller the zoom level, the bigger zones radiuses
    List<double> zoomBiasValues = [10, 9.25, 8.5, 7.75, 7, 6.25, 5.5, 4.75, 4, 3.25, 2.5, 1.75, 1];
    int zoomIndex = zoomLevel.floor() - 9;

    // restricting zoom index on big screen resolutions
    if (zoomIndex < 9) zoomIndex = 0;
    if (zoomIndex > 21) zoomIndex = 12;
    double radius = popularity * zoomBiasValues[zoomIndex];

    List<LatLng> points = createRandomPoints(center, radius, popularity);
    int index = 0;

    for (LatLng point in points) {
      final String id = '$placeId${index++}';
      pointsCache[id] = WeightedLatLng( point: point );
    }

    return pointsCache;
  }
}