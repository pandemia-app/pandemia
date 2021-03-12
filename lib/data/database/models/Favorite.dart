import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';

/// This entity allows the user to store favorite places.
/// It is used to display popularity stats.
class Favorite {
  final String id;
  final String name;
  final String address;
  final Map<int, int> attendance;
  bool isExpanded;

  Favorite ({this.id, this.name, this.address, this.attendance, this.isExpanded = true});

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