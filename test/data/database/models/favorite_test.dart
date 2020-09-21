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

  test("should not accept null name", () {
    expect(() {
      Favorite(id: "id", name: null, address: "a");
    }, throwsAssertionError);
  });

  test("should not accept empty string as name", () {
    expect(() {
      Favorite(id: "id", name: "", address: "a");
    }, throwsAssertionError);
  });

  test("should not accept null address", () {
    expect(() {
      Favorite(id: "id", name: "n", address: null);
    }, throwsAssertionError);
  });

  test("should not accept empty string as address", () {
    expect(() {
      Favorite(id: "id", name: "n", address: "");
    }, throwsAssertionError);
  });
}