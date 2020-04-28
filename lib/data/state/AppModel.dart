import 'package:flutter/cupertino.dart';
import 'package:pandemia/data/database/database.dart';

class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  AppDatabase database = new AppDatabase();
  setTabIndex (int index) {
    print(index);
    this.tabIndex = index;
    notifyListeners();
  }
}