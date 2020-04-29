import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pandemia/data/database/database.dart';

class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  AppDatabase database = new AppDatabase();
  static String apiKey = DotEnv().env['GMAPS_PLACES_API_KEY'];
  setTabIndex (int index) {
    print(index);
    this.tabIndex = index;
    notifyListeners();
  }
}