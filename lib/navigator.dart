import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/views/favorites/view.dart';
import 'package:pandemia/views/home.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:provider/provider.dart';
import 'data/state/AppModel.dart';
import 'main.dart';

class BottomNavigationWidgetState extends State<MyHomePage> {
  final String title;
  BottomNavigationWidgetState({Key key, this.title}) : super ();

  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  final List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    PlacesView(),
    FavoritesView()
  ];

  void _onItemTapped(int index) {
    Provider.of<AppModel>(context, listen: false).setTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
        builder: (context, model, child) {
          return Scaffold(

            /*
      appBar: AppBar(
        title: const Text('Pandemia #StayAtHome'),
        backgroundColor: CustomPalette.palette[800],
        centerTitle: true
      ),
      */

            body: Center(
              child: _widgetOptions.elementAt(model.tabIndex),
            ),

            backgroundColor: CustomPalette.background[700],
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  title: Text('Places'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  title: Text('Favorites'),
                ),
              ],
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
}