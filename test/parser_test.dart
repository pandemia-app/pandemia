import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/populartimes/parser.dart';
import 'package:pandemia/main.dart';

void main() {
  testWidgets('Correctly get popular times for a given place', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    String placeId = "ChIJ36KsmTnWwkcRvQqaRytgL48";
    // var times = Parser.getPopularTimes(placeId);
  });
}
