import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesAPIResult {
  final String placeId;
  final String name;
  final String address;
  final LatLng location;

  PlacesAPIResult ({
    @required this.placeId,
    this.name, this.address, this.location });

  factory PlacesAPIResult.fromJSON (dynamic json) {
    return PlacesAPIResult(
      placeId: json['place_id'],
      name: json['name'],
      address: json['vicinity'],
      location: LatLng (
          json['geometry']['location']['lat'],
          json['geometry']['location']['lng']
      )
    );
  }
}