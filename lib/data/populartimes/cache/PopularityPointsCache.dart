import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/utils/GeoComputer.dart';

class PopularityPointsCache {
  Map<String, Map<String, WeightedLatLng>> points = new Map();
  Map<String, double> zoomLevels = new Map();
  GeoComputer computer = new GeoComputer();

  Map<String, WeightedLatLng> getPoints (String placeId, LatLng placePosition, int placeCurrentPopularity, double zoomLevel) {
    if (this.points[placeId] == null || this.zoomLevels[placeId] != zoomLevel) {
      points[placeId] = computer.generatePopularityPoints(placePosition, placeId, placeCurrentPopularity, zoomLevel);
    }

    zoomLevels[placeId] = zoomLevel;

    return points[placeId];
  }
}