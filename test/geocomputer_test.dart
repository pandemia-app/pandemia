import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/utils/GeoComputer.dart';
import 'package:test/test.dart';

void main() {
  GeoComputer computer;
  setUp(() async {
    computer = new GeoComputer();
  });

  group('Geocomputer tests', () {
    test('should return square centre location', () {
      LatLngBounds bounds = new LatLngBounds(southwest: LatLng(2, 4), northeast: LatLng(4, 2));
      LatLng center = computer.getBoundsCenterLocation(bounds);
      expect(center, LatLng(3, 3));
    });

    test('should return rectangular (lng>lat) centre location', () {
      LatLngBounds bounds = new LatLngBounds(southwest: LatLng(0, 0), northeast: LatLng(5, 3));
      LatLng center = computer.getBoundsCenterLocation(bounds);
      expect(center, LatLng(2.5, 1.5));
    });

    test('should return rectangular (lat>lng) centre location', () {
      LatLngBounds bounds = new LatLngBounds(southwest: LatLng(2, 3), northeast: LatLng(4, 13));
      LatLng center = computer.getBoundsCenterLocation(bounds);
      expect(center, LatLng(3, 8));
    });

    test('should return same location', () {
      LatLngBounds bounds = new LatLngBounds(southwest: LatLng(7, 7), northeast: LatLng(7, 7));
      LatLng center = computer.getBoundsCenterLocation(bounds);
      expect(center, LatLng(7, 7));
    });
  });
}