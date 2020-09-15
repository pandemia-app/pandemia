import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/views/favorites/view.dart';
import 'package:pandemia/views/home.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'main.dart';

/// Main application state, which holds its three views.
/// Navigation between them is possible thanks to a bottom navigation menu.
class BottomNavigationWidgetState extends State<MyHomePage> {
  final String title;
  final AppDatabase db = new AppDatabase();
  BottomNavigationWidgetState({Key key, this.title}) : super ();

  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  final List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    PlacesView(),
    FavoritesView()
  ];

  /// Changes the displayed view when a menu item is tapped.
  void _onItemTapped(int index) {
    db.open().then((erg) async {
      var loc = new Location(id: 0, lat: 3.14, lng: 55.42, timestamp: DateTime.now().millisecondsSinceEpoch);
      await db.insertLocation(loc);
      print (await db.getLocations());
      return print("db opened");
    });

    Provider.of<AppModel>(context, listen: false).setTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(model.tabIndex),
            ),

            backgroundColor: CustomPalette.background[700],
            bottomNavigationBar: BottomNavigationBar(
              items: getNavigationItems(),
              currentIndex: model.tabIndex,
              backgroundColor: CustomPalette.background[500],
              unselectedItemColor: CustomPalette.text[600],
              selectedItemColor: Color(0xFF63aeff),
              onTap: _onItemTapped,
            ),
          );
        }
    );
  }

  /// Bottom navigation menu items.
  List<BottomNavigationBarItem> getNavigationItems () {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text(FlutterI18n.translate(context, "navigator_home")),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text(FlutterI18n.translate(context, "navigator_places")),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.star),
        title: Text(FlutterI18n.translate(context, "navigator_favorites")),
      ),
    ];
  }
}