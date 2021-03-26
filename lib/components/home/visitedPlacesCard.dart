import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pandemia/utils/geolocation/VisitedPlacesComputer.dart';
import 'package:provider/provider.dart';

/// Map card showing places the user visited today.
class VisitedPlacesCard extends StatefulWidget {
  static final LatLng _center = const LatLng(50.6311652, 3.0477402);
  static final AppDatabase db = new AppDatabase();
  const VisitedPlacesCard ({Key key}) : super(key: key);

  @override
  State<VisitedPlacesCard> createState() => VisitedPlacesCardState();
}

class VisitedPlacesCardState extends State<VisitedPlacesCard> {
  String _mapStyle;

  VisitedPlacesCardState() {
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
                                child: _buildMap(snapshot, model),
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
                              getPlacesTitle(context, snapshot, model),
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
      AsyncSnapshot<List<Location>> snapshot,
      AppModel model) {

    if (!snapshot.hasData) {
      return "Computing results...";
    }

    List<Location> locations = VisitedPlacesComputer.getRecentLocations(snapshot.data);
    int locationsCount = locations.length;

    return
      "$locationsCount ${FlutterI18n.translate(context, "word_location")}"
        + (locationsCount > 1 ? 's' : '') + " - "
      "${model.visitedPlacesMarkers.length} " + FlutterI18n.translate(context, "word_place")
        + (model.visitedPlacesMarkers.length > 1 ? 's' : '');
  }

  GoogleMap _buildMap (AsyncSnapshot<List<Location>> snapshot, AppModel model) {
    if (!snapshot.hasData || snapshot.data.length == 0) {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: VisitedPlacesCard._center,
          zoom: 13.75,
        ),
        markers: model.visitedPlacesMarkers.toSet(),
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
      );
    }

    List<WeightedLatLng> points =
      VisitedPlacesComputer.getRecentLocations(snapshot.data)
        .map((e) => WeightedLatLng(point: e.toLatLng())).toList();

    return GoogleMap(
      initialCameraPosition: points.length == 0
          ? VisitedPlacesCard._center
          : CameraPosition(
        target: points[0].point,
        zoom: 13.75,
      ),
      heatmaps: [
        Heatmap (
          points: points,
          heatmapId: HeatmapId(DateTime.now().toIso8601String())
        )
      ].toSet(),
      markers: model.visitedPlacesMarkers.toSet(),
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
    );
  }
}