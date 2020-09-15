import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';
import 'package:pandemia/utils/GeoComputer.dart';

/// Stores points representing the current popularity of a given place.
class PopularityPointsCache {
  Map<String, Map<String, WeightedLatLng>> points = new Map();
  Map<String, double> zoomLevels = new Map();
  Map<String, int> popularities = new Map();
  GeoComputer computer = new GeoComputer();

  /// Returns points for a given place.
  /// Regenerates points if the zoom level or place popularity changed since last request.
  Map<String, WeightedLatLng> getPoints (PlacesAPIResult place, int placeCurrentPopularity, double zoomLevel) {
    String placeId = place.placeId;
    if (this.points[placeId] == null || this.zoomLevels[placeId] != zoomLevel || this.popularities[placeId] != placeCurrentPopularity) {
      points[placeId] = computer.generatePopularityPoints(place.location, placeId, placeCurrentPopularity, zoomLevel);
    }

    zoomLevels[placeId] = zoomLevel;
    popularities[placeId] = placeCurrentPopularity;

    return points[placeId];
  }
}