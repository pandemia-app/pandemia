import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/components/places/search/placeCard.dart';
import 'package:pandemia/components/places/search/searchBar.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/views/places/places.dart';

class PlacesState extends State<PlacesView> {
  GoogleMapController mapController;
  String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  final searchBar = new SearchBar();
  Favorite fPlace;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    controller.setMapStyle(_mapStyle);
    searchBar.mapController = controller;
    searchBar.callback = (dynamic place) {
      print(place);
      setState(() {
        fPlace =
            Favorite(address: place['formatted_address'], name: place['name'],
            id: place['place_id']);
        print(fPlace);
      });
    };
    searchBar.closeCallback = () {
      setState(() {
        fPlace = null;
      });
    };
  }

  void getAllPlacesInViewport () async {
    print('getting all places in viewport');
    var bounds = await mapController.getVisibleRegion();
    print(bounds);
  }

  @override
  Widget build(BuildContext context) {
    searchBar.fatherContext = context;
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
              onCameraIdle: () => getAllPlacesInViewport(),
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
              child: PlaceCard(place: fPlace, mainContext: context)
            )
          ],
        )
      ),
    );
  }
}