import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/utils/GeoComputer.dart';
import 'package:pandemia/utils/Preferences.dart';
import 'package:pandemia/utils/placesMap/SearchZone.dart';

class PlacesMapController {
  GoogleMapController controller;
  PlacesMapController ({this.controller});
  GeoComputer computer = new GeoComputer();

  static final LatLng defaultCenter = const LatLng(47.204780651359876, 0.08437223732471466);
  static final double _defaultZoomLevel = 5.6872239112854;

  void initCamera () async {
    controller.moveCamera(CameraUpdate.newLatLngZoom(LatLng(
        Preferences.storage.getDouble('favoriteMapLat') != null ? Preferences.storage.getDouble('favoriteMapLat') : defaultCenter.latitude,
        Preferences.storage.getDouble('favoriteMapLng') != null ? Preferences.storage.getDouble('favoriteMapLng') : defaultCenter.longitude
    ),
        Preferences.storage.getDouble('favoriteMapZoom') != null ? Preferences.storage.getDouble('favoriteMapZoom') : _defaultZoomLevel));
  }

  Future<CircularSearchZone> getCurrentSearchZone () async {
    var bounds = await controller.getVisibleRegion();
    return CircularSearchZone (
      center: computer.getBoundsCenterLocation(bounds),
      radius: computer.getSearchRadius(bounds)
    );
  }
}