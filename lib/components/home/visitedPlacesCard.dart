import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:flutter/services.dart' show rootBundle;

class VisitedPlacesCard extends StatelessWidget {
  static String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  VisitedPlacesCard(String title) {
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container (
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomPalette.background[900]),
                  borderRadius: new BorderRadius.all(const Radius.circular(5.0))
              ),
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
                    myLocationButtonEnabled: false,
                    buildingsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationEnabled: false,
                    trafficEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: false,
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
                  color: CustomPalette.text[100],
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
                    color: CustomPalette.text[600],
                    fontSize: 18,
                    fontWeight: FontWeight.w300
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
          )
        ],
        fit: StackFit.expand,
      )
    );
  }
}