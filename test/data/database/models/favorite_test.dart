import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Favorite.dart';

void main () {
  test("should not accept null id", () {
    expect(() {
      Favorite (id: null,);
    }, throwsAssertionError);
  });

  test("should not accept empty string as id", () {
    expect(() {
      Favorite(id: "");
    }, throwsAssertionError);
  });
}