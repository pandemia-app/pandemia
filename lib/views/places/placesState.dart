import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter_heatmap/google_maps_flutter_heatmap.dart';
import 'package:pandemia/utils/map/Heatmap.dart';
import 'package:pandemia/views/places/places.dart';

class PlacesState extends State<PlacesView> {
  GoogleMapController mapController;
  String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    controller.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    final Set<Heatmap> _heatmaps = new Set();
    _heatmaps.add(
        Heatmap(
            heatmapId: HeatmapId("42"),
            points: HeatmapUtils.points,
            radius: 15,
            visible: true,
            opacity: 1,
            transparency: 0,
            gradient:  HeatmapGradient(
                colors: <Color>[Colors.green, Colors.red], startPoints: <double>[0.2, 0.8]
            )
        )
    );
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.75,
          ),
          heatmaps: _heatmaps,
        ),
      ),
    );
  }
}