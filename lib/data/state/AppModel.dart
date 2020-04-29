import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  static String apiKey = DotEnv().env['GMAPS_PLACES_API_KEY'];
  setTabIndex (int index) {
    print(index);
    this.tabIndex = index;
    notifyListeners();
  }
}