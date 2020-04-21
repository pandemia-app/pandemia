class Location {
  final int id;
  final double lat;
  final double lng;
  final int timestamp;

  Location ({this.id, this.lat, this.lng, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'date': timestamp
    };
  }
}