import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:flutter/services.dart' show rootBundle;

class VisitedPlacesCard extends CustomCard {
  static String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  VisitedPlacesCard(String title) : super('') {
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: new ClipRRect(
            borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
            child: Align(
              alignment: Alignment.bottomRight,
              heightFactor: 0.3,
              widthFactor: 2.5,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.75,
                ),
                onMapCreated: (GoogleMapController c) {
                  c.setMapStyle(_mapStyle);
                },
              ),
            ),
          )
        ),

        Container(
          child: new Text(
            "Locations I've visited today",
            style: TextStyle(
              color: CustomPalette.palette[50],
              fontSize: 20,
              fontWeight: FontWeight.w300
            ),
          ),
          padding: EdgeInsets.all(10.0),
        ),

        Container(
          child: new Text(
            "0 place",
            style: TextStyle(
                color: CustomPalette.palette[100],
                fontSize: 18,
                fontWeight: FontWeight.w300
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
        )
      ],
      fit: StackFit.expand,
    );
  }
}