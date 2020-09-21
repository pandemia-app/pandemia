import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/state/AppModel.dart';

void main() {
  AppModel _model;
  setUp(() {
    _model = AppModel();
  });

  test("should be initialised with default values", () {
    expect(_model.tabIndex, 0);
    expect(_model.reports, []);
  });

  test("should set tab index", () {
    expect(_model.tabIndex, 0);
    _model.setTabIndex(2);
    expect(_model.tabIndex, 2);
  });

  // there are only 3 tabs, index varies from 0 to 2 included
  test("should not set tab index", () {
    expect(() {
      _model.setTabIndex(3);
    }, throwsAssertionError);
  });

  test("should not set negative tab index", () {
    expect(() {
      _model.setTabIndex(-1);
    }, throwsAssertionError);
  });

  test("should not set null tab index", () {
    expect(() {
      _model.setTabIndex(null);
    }, throwsAssertionError);
  });
}