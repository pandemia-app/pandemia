import 'package:flutter/cupertino.dart';

class AppModel extends ChangeNotifier {
  int tabIndex = 0;
  setTabIndex (int index) {
    print(index);
    this.tabIndex = index;
    notifyListeners();
  }
}