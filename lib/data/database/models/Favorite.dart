import 'package:flutter/cupertino.dart';
import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';

/// This entity allows the user to store favorite places.
/// It is used to display popularity stats.
class Favorite {
  final String id;
  final String name;
  final String address;
  bool isExpanded;

  Favorite ({
    @required this.id,
    @required this.name,
    @required this.address,
    this.isExpanded = true
  }) :  assert(id != null),
        assert(id.length > 0),
        assert(name != null),
        assert(name.length > 0),
        assert(address != null),
        assert(address.length > 0);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address
    };
  }

  @override
  String toString() {
    return 'Favorite{name: $name, address: $address}';
  }

  String getIdentifier() {
    return '$name $address';
  }

  factory Favorite.fromPlacesAPIResult(PlacesAPIResult result) {
    return Favorite(
      name: result.name,
      address: result.address,
      id: result.placeId
    );
  }
}