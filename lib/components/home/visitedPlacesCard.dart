import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

/// Map card showing places the user visited today.
class VisitedPlacesCard extends StatelessWidget {
  static String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  VisitedPlacesCard() {
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel> (
      builder: (context, model, child) {
        return GestureDetector(
            onTap: () => model.setTabIndex(1),
            child: Container (
                height: 350,
                margin: const EdgeInsets.all(20),
                child: FutureBuilder(
                  future: model.database.getLocations(),
                  builder: (BuildContext context, AsyncSnapshot<List<Location>> snapshot) {
                    return Stack(
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
                                child: Consumer<AppModel> (
                                  builder: (context, model, child) => GoogleMap(
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
                              ),
                            )
                        ),

                        Container(
                          child: new Text(
                            FlutterI18n.translate(context, "home_places_title"),
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
                              getPlacesTitle(context, snapshot),
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
                    );
                  },
                )
            )
        );
      },
    );
  }

  String getPlacesTitle (
      BuildContext context,
      AsyncSnapshot<List<Location>> snapshot) {

    if (!snapshot.hasData) {
      return "";
    }

    int locationsCount = snapshot.data.length,
        placesCount = 0;

    return
      "$locationsCount ${FlutterI18n.translate(context, "word_location")}"
        + (locationsCount > 1 ? 's' : '') + " - "
      "$placesCount " + FlutterI18n.translate(context, "word_place")
        + (placesCount > 1 ? 's' : '');
  }
}