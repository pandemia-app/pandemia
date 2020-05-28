import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Is in charge of geolocation-related computation.
class GeoComputer {
  // https://stackoverflow.com/questions/43195899/how-to-generate-random-coordinates-within-a-circle-with-specified-radius
  double degree = 6371 * 2 * pi / 360 * 1000; // 1° latitude in meters

  /// Returns random coordinates [x, y] included in a circle.
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
  List<LatLng> createRandomPoints (LatLng center, String placeId, int popularity) {
    List<LatLng> points = new List();
    for (int i=0; i<popularity; i++) {
      List<double> randomCoordinates = randomPointInDisk(popularity.toDouble());
      double dx = randomCoordinates.first;
      double dy = randomCoordinates.last;

      points.add(
          new LatLng(
              center.latitude + dy / degree,
              center.longitude + dx / degree));
    }
    return points;
  }
}