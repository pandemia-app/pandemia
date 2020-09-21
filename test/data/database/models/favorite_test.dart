import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Favorite.dart';

void main () {
  test("should not accept null id", () {
    expect(() {
      Favorite (id: null, name: "n", address: "a");
    }, throwsAssertionError);
  });

  test("should not accept empty string as id", () {
    expect(() {
      Favorite(id: "", name: "n", address: "a");
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

  test("favorite is expanded by default", () {
    Favorite f = Favorite(id: "id", address: "address", name: "name");
    expect(f.isExpanded, true);
  });

  test("should convert object to map", () {
    Favorite f = Favorite(id: "id", address: "address", name: "name");
    Map<String, dynamic> map = f.toMap();

    expect(map.containsKey("id"), true);
    expect(map["id"], "id");
    expect(map.containsKey("name"), true);
    expect(map["name"], "name");
    expect(map.containsKey("address"), true);
    expect(map["address"], "address");
  });
}