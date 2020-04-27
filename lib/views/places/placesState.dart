import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:pandemia/views/places/search/placeCard.dart';
import 'package:pandemia/views/places/search/searchBar.dart';

class PlacesState extends State<PlacesView> {
  GoogleMapController mapController;
  String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  final searchBar = new SearchBar();
  String pName;
  String pAddress;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    controller.setMapStyle(_mapStyle);
    searchBar.mapController = controller;
    searchBar.callback = (dynamic place) {
      print(place);
      setState(() {
        pName = place['name'];
        pAddress = place['formatted_address'];
      });
    };
    searchBar.closeCallback = () {
      setState(() {
        pName = null;
        pAddress = null;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Stack (
          fit: StackFit.passthrough,
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.75,
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: searchBar,
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: PlaceCard(name: pName, address: pAddress)
            )
          ],
        )
      ),
    );
  }
}