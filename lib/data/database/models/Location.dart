/// Locations gathered by the user's smartphone.
class Location {
  final int id;
  final double lat;
  final double lng;
  final int timestamp;

  Location ({this.id, this.lat, this.lng, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'date': timestamp
    };
  }

  @override
  String toString() {
    return 'Location{id: $id, lat: $lat, lng: $lng, date: $timestamp}';
  }


}