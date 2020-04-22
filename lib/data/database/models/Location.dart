class Location {
  final int id;
  final double lat;
  final double lng;
  final DateTime timestamp;

  Location ({this.id, this.lat, this.lng, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'date': timestamp.millisecondsSinceEpoch
    };
  }

  @override
  String toString() {
    return '{lat: $lat, lng: $lng, date: $timestamp}';
  }


}