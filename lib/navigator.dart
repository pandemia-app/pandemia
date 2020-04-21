import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/database/database.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/views/home.dart';
import 'package:pandemia/views/places/places.dart';
import 'main.dart';

class BottomNavigationWidgetState extends State<MyHomePage> {
  final String title;
  final LocationsDatabase db = new LocationsDatabase();
  BottomNavigationWidgetState({Key key, this.title}) : super ();
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  final List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    PlacesView(),
    Text(
      'Index 2: Favorites',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    db.open().then((erg) { return print("db opened"); });
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /*
      appBar: AppBar(
        title: const Text('Pandemia #StayAtHome'),
        backgroundColor: CustomPalette.palette[800],
        centerTitle: true
      ),
      */

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        backgroundColor: CustomPalette.background[500],
        unselectedItemColor: CustomPalette.text[600],
        selectedItemColor: Color(0xFF63aeff),
        onTap: _onItemTapped,
      ),
    );
  }
}