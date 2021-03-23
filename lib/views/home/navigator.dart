import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/main.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/views/favorites/view.dart';
import 'package:pandemia/views/home/home.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../data/state/AppModel.dart';
import '../../main.dart';

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
    Provider.of<AppModel>(context, listen: false).setTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    // checking location service status if permission has been granted
    Permission.locationAlways.isGranted.then((value) {
      if (!value) return;
      Permission.locationAlways.serviceStatus.then((value) {
        if (value.isDisabled) {
          Fluttertoast.showToast(
              msg: FlutterI18n.translate(context, "location_service_disabled"),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4,
              fontSize: 16.0
          );
        }
      });
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Consumer<AppModel>(
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
      ),
    );
  }

  /// Bottom navigation menu items.
  List<BottomNavigationBarItem> getNavigationItems () {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: FlutterI18n.translate(context, "navigator_home"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: FlutterI18n.translate(context, "navigator_places"),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.star),
        label: FlutterI18n.translate(context, "navigator_favorites"),
      ),
    ];
  }
}