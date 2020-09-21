import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';

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

  test("should convert object to string", () {
    Favorite f = Favorite(
      id: "inria",
      name: "Inria Spirals",
      address: "40 Avenue Halley, 59650 Villeneuve-d'Ascq"
    );

    String s = f.toString();
    expect(s, "Favorite[name: Inria Spirals, address: 40 Avenue Halley, 59650 Villeneuve-d'Ascq]");
  });

  test("should get identifier", () {
    Favorite f = Favorite(
        id: "inria",
        name: "Inria Spirals",
        address: "40 Avenue Halley, 59650 Villeneuve-d'Ascq"
    );

    String identifier = f.getIdentifier();
    expect(identifier, "Inria Spirals 40 Avenue Halley, 59650 Villeneuve-d'Ascq");
  });

  test("can be built from a PlacesAPIResult instance", () {
    PlacesAPIResult result = PlacesAPIResult(
      placeId: "id",
      name: "name",
      address: "address",
      location: null
    );

    Favorite f = Favorite.fromPlacesAPIResult(result);
    expect(f.name, "name");
    expect(f.address, "address");
    expect(f.id, "id");
  });
}