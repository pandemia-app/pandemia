import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoComputer {
  // https://stackoverflow.com/questions/43195899/how-to-generate-random-coordinates-within-a-circle-with-specified-radius
  double OneDegree = 6371 * 2 * pi / 360 * 1000; // 1° latitude in meters

  List<double> randomPointInDisk (double maxRadius) {
    Random random = Random.secure();
    double r = maxRadius * random.nextDouble() * 0.5;
    double theta = random.nextDouble() * 2 * pi;
    return [
      r * cos(theta),
      r * sin(theta)
    ];
  }

  List<LatLng> createRandomPoints (LatLng center, String placeId, int popularity) {
    List<LatLng> points = new List();
    for (int i=0; i<popularity; i++) {
      List<double> randomCoordinates = randomPointInDisk(popularity.toDouble());
      double dx = randomCoordinates.first;
      double dy = randomCoordinates.last;

      points.add(
          new LatLng(
              center.latitude + dy / OneDegree,
              center.longitude + dx / OneDegree));
    }
    return points;
  }
}