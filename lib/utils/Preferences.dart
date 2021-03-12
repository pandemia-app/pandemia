import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences storage;
  static init () async {
    storage = await SharedPreferences.getInstance();
  }
}