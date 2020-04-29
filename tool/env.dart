import 'dart:io';

Future<void> main() async {
  final filename = 'lib/.env.generated';
  File(filename).writeAsString(
      'GMAPS_PLACES_API_KEY="${Platform.environment['GMAPS_PLACES_API_KEY']}"');
}