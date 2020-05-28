import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:pandemia/components/places/search/placeCard.dart';
import 'package:pandemia/components/places/search/searchBar.dart';
import 'package:pandemia/components/places/type/placeType.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/GeoComputer.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:http/http.dart' as http;

class PlacesState extends State<PlacesView> {
  GoogleMapController mapController;
  String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  final searchBar = new SearchBar();
  List<Polyline> searchZones = [];
  Favorite fPlace;
  String selectedType = "supermarket";
  Map<HeatmapId, Heatmap> heatmaps = <HeatmapId, Heatmap>{};
  Map<HeatmapId, Heatmap> popularityMaps = <HeatmapId, Heatmap>{};
  bool loadingPlaces = true;

  void _onMapCreated(GoogleMapController controller, BuildContext context) {
    mapController = controller;
    controller.setMapStyle(_mapStyle);
    getAllPlacesInViewport(context);
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

  void setPlaceType (String placeKey, BuildContext context) {
    setState(() {
      selectedType = placeKey;
    });
    print('place type is set to $placeKey');

    // refreshing view with new place type
    getAllPlacesInViewport(context);
  }

  void getAllPlacesInViewport (BuildContext context) async {
    // abort if called before mapController is ready
    if (mapController == null) return;

    print('getting all places in viewport');
    var bounds = await mapController.getVisibleRegion();

    // computing middle location
    var middle = new LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2
    );
    LatLng edgeMarker = new LatLng(middle.latitude, bounds.northeast.longitude);

    // computing search radius
    final latlong.Distance distance = new latlong.Distance();
    final double meters = distance(
        new latlong.LatLng(middle.latitude, middle.longitude),
        new latlong.LatLng(edgeMarker.latitude, edgeMarker.longitude));

    // aborting if distance computation failed
    if (middle.longitude == 0.0 && middle.latitude == 0.0 || meters == 0.0) {
      print('aborting');
      return;
    }

    // checking maximum distance
    if (meters > 50000) {
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(context, "places_searchzone_toobig"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          fontSize: 16.0
      );
      return;
    }

    setState(() {
      loadingPlaces = true;
    });

    String key = AppModel.apiKey;
    const host = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final uri = Uri.parse('$host?location=${middle.latitude},${middle.longitude}&radius=$meters&type=$selectedType&key=$key');
    print('hitting $uri');

    http.Response response = await http.get (uri);
    final responseJson = json.decode(response.body);
    var results = responseJson['results'];

    // display a message if no results were found
    if (results.length == 0) {
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(context, "places_searchzone_noresult"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          fontSize: 16.0
      );
    }

    // adds a marker for each place
    for (var result in results) {
      final HeatmapId id = HeatmapId(result['id']);
      setState(() {
        heatmaps[id] = Heatmap (
          heatmapId: id,
          points: [
            WeightedLatLng(
              point: LatLng(
                result['geometry']['location']['lat'],
                result['geometry']['location']['lng'],
              )
            )
          ]
        );
      });

      // refresh data with popularity stats
      Parser.getPopularTimes(new Favorite(name: result['name'], address: result['vicinity'])).then((value) {
        if (value.hasData) {
          addPopularityPoints(
              LatLng(
                result['geometry']['location']['lat'],
                result['geometry']['location']['lng'],
              ),
              result['id'], value.currentPopularity);
        }
      });
    }

    setState(() {
      loadingPlaces = false;
    });
  }

  void addPopularityPoints (LatLng center, String placeId, int popularity) {
    var computer = new GeoComputer();
    List<LatLng> points = computer.createRandomPoints(center, placeId, (popularity*0.5).floor());
    int index = 0;
    popularityMaps.clear();

    for (LatLng point in points) {
      final HeatmapId id = HeatmapId('$placeId${index++}');
      // TODO find a less intensive way of adding points to the map
      popularityMaps[id] = Heatmap(
          heatmapId: id,
          points: [
            WeightedLatLng( point: point )
          ]
      );
    }

    setState(() {
      heatmaps.addAll(popularityMaps);
    });
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
              onMapCreated: (controller) => _onMapCreated(controller, context),
              onCameraIdle: () => getAllPlacesInViewport(context),
              polylines: searchZones.toSet(),
              heatmaps: Set<Heatmap>.of(heatmaps.values),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 13.75,
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: searchBar,
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.09,
              minChildSize: 0.09,
              builder: (BuildContext localContext, ScrollController scrollController) {
                List<Widget> typesItems = [
                  ListTile(
                  title: Center(
                    child: Column (
                      children: <Widget>[
                        Icon(Icons.maximize, color: CustomPalette.text[700]),
                        Container (
                          child: Text(FlutterI18n.translate(context, "places_typepicker_title"), style: TextStyle(
                              color: CustomPalette.text[300])),
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Divider (color: CustomPalette.text[300], thickness: 0.5,)
                      ],
                    ),
                  ),
                )];
                for (PlaceType t in PlaceType.getSortedTypes(context)) {
                  typesItems.add(
                      ListTile(
                        onTap: () {
                          heatmaps.clear();
                          setPlaceType(t.key, context);},
                        dense: true,
                        enabled: true,
                        title: Text(t.translation, style: TextStyle(color: CustomPalette.text[300])),
                        leading: Radio(
                          groupValue: selectedType,
                          value: t.key,
                          onChanged: (key) {
                            heatmaps.clear();
                            setPlaceType(key, context);}
                        ),
                      )
                  );
                }

                return Container(
                  color: CustomPalette.background[400],
                  child: ListView(
                    controller: scrollController,
                    children: typesItems,
                  )
                );
              },
            ),

            Align(
                alignment: Alignment.bottomCenter,
                child: PlaceCard(place: fPlace, mainContext: context)
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility (
                visible: loadingPlaces,
                child: LinearProgressIndicator(),
              )
            )
          ],
        )
      ),
    );
  }
}