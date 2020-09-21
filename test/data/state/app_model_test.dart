import 'package:flutter_test/flutter_test.dart';
import 'package:pandemia/data/state/AppModel.dart';

void main() {
  AppModel _model;

  test("should be initialised with default values", () {
    _model = AppModel();
    expect(_model.tabIndex, 0);
    expect(_model.reports, []);
  });
}