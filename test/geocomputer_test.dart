import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:pandemia/utils/GeoComputer.dart';

void main() {
  GeoComputer computer;
  final latlong.Distance distance = new latlong.Distance();
  setUp(() async {
    computer = new GeoComputer();
  });

  group('getBoundsCenterLocation()', () {
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

  group('Search radius computing', () {
    test('should return 0 for non-existent zone', () {
      LatLngBounds bounds = new LatLngBounds(southwest: LatLng(42, 3), northeast: LatLng(42, 3));
      double radius = computer.getSearchRadius(bounds);
      expect(radius, 0.0);
    });

    // the following tests use pre-computed values to ensure order of returned
    // values is coherent
    test('should return a radius for a portrait-oriented zone', () {
      LatLngBounds bounds = new LatLngBounds(
        northeast: LatLng(50.486364, 3.386926),
        southwest: LatLng(50.401621, 3.286566)
      );
      double radius = computer.getSearchRadius(bounds);
      expect(radius, 4713);
    });

    test('should return a radius for a landscape-oriented zone', () {
      LatLngBounds bounds = new LatLngBounds(
          northeast: LatLng(50.239105, 4.345443),
          southwest: LatLng(49.628964, 1.061071)
      );
      double radius = computer.getSearchRadius(bounds);
      expect(radius, 117896);
    });

    test('should return a radius with bounds including negative longitude', () {
      LatLngBounds bounds = new LatLngBounds(
          northeast: LatLng(50.595359, 0.104460),
          southwest: LatLng(50.550336, -0.076399)
      );
      double radius = computer.getSearchRadius(bounds);
      expect(radius, 6406);
    });

    test('should return a radius with bounds including negative latitude', () {
      LatLngBounds bounds = new LatLngBounds(
          northeast: LatLng(0.485556, 23.143687),
          southwest: LatLng(-0.449652, 18.868404)
      );
      double radius = computer.getSearchRadius(bounds);
      expect(radius, 237961);
    });
  });

  group('Random location generation', () {
    test('should generate 0 locations', () {
      List<LatLng> points = computer.createRandomPoints(LatLng(50.605181, 3.149249), 40, 0);
      expect(points.length, 0);
    });

    test('should generate 420 locations precisely', () {
      List<LatLng> points = computer.createRandomPoints(LatLng(50.605181, 3.149249), 40, 420);
      expect(points.length, 420);
    });

    test('should generate 10000 points inside a given circular zone', () {
      LatLng center = LatLng(50.605181, 3.149249);
      double radius = 42;
      List<LatLng> points = computer.createRandomPoints(center, radius, 10000);
      expect(points.length, 10000);

      for (LatLng point in points) {
        expect(
          distance (
            latlong.LatLng(center.latitude, center.longitude),
            latlong.LatLng(point.latitude, point.longitude)
          ),
            allOf([
              isNonNegative,
              lessThan(radius)
            ])
        );
      }
    });
  });
}