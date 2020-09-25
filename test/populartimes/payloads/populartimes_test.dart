import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';

void main() {
  test("should not create an instance with null hasData", () {
    expect(() {
      new PopularTimes(hasData: null);
    }, throwsAssertionError);
  });
}