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
import 'package:pandemia/utils/PlacesCounter.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:http/http.dart' as http;

class PlacesState extends State<PlacesView> {
  GoogleMapController mapController;
  String _mapStyle;
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  final searchBar = new SearchBar();
  Favorite fPlace;
  String selectedType = "supermarket";
  Map<String, WeightedLatLng> heatmapPoints = <String, WeightedLatLng>{};
  bool loadingPlaces = true;
  double zoomLevel = 13.75;

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
    LatLng eastMarker = new LatLng(middle.latitude, bounds.northeast.longitude);
    LatLng northMarker = new LatLng(bounds.northeast.latitude, middle.longitude);

    // search radius is the maximum value of two distances :
    // 1) from screen middle to screen northern location
    // 2) from screen middle to screen eastern location
    final latlong.Distance distance = new latlong.Distance();
    final double eastDistance = distance(
        new latlong.LatLng(middle.latitude, middle.longitude),
        new latlong.LatLng(eastMarker.latitude, eastMarker.longitude));
    final double northDistance = distance (
        new latlong.LatLng(middle.latitude, middle.longitude),
        new latlong.LatLng(northMarker.latitude, northMarker.longitude)
    );
    double meters = max (eastDistance, northDistance);

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
      setState(() {
        loadingPlaces = false;
      });
    }

    // this counter allows to adds all points at once, when all places data have
    // been loaded.
    PlacesCounter counter = new PlacesCounter();
    counter.setPlacesCount(results.length);
    Map<String, WeightedLatLng> pointsCache = <String, WeightedLatLng>{};

    // adds a marker for each place
    for (var result in results) {
      pointsCache[result['id']] =
          WeightedLatLng(
            point: LatLng(
              result['geometry']['location']['lat'],
              result['geometry']['location']['lng'],
            )
          );

      // refresh data with popularity stats
      Parser.getPopularTimes(new Favorite(name: result['name'], address: result['vicinity'])).then((value) {
        if (value.hasData) {
          var placePointsCache = getPopularityPoints(
              LatLng(
                result['geometry']['location']['lat'],
                result['geometry']['location']['lng'],
              ),
              result['id'], value.currentPopularity);
          pointsCache.addAll(placePointsCache);
        }

        if (counter.addLoadedPlace()) {
          setState(() {
            heatmapPoints.addAll(pointsCache);
            loadingPlaces = false;
          });
        }
      });
    }
  }

  Map<String, WeightedLatLng> getPopularityPoints (LatLng center, String placeId, int popularity) {
    var computer = new GeoComputer();
    Map<String, WeightedLatLng> pointsCache = <String, WeightedLatLng>{};
    // zoom level can vary from 21 to ~9.9
    List<LatLng> points = computer.createRandomPoints(center, placeId, popularity);
    int index = 0;

    for (LatLng point in points) {
      final String id = '$placeId${index++}';
      pointsCache[id] = WeightedLatLng( point: point );
    }

    return pointsCache;
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
              onCameraMove: (position) => zoomLevel = position.zoom,
              onMapCreated: (controller) => _onMapCreated(controller, context),
              onCameraIdle: () => getAllPlacesInViewport(context),
              heatmaps: Set<Heatmap>.of([
                Heatmap (
                  heatmapId: HeatmapId(DateTime.now().toIso8601String()),
                  points: heatmapPoints.values.length == 0 ? [WeightedLatLng(point: LatLng(0, 0))] : heatmapPoints.values.toList()
                )
              ]),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: zoomLevel,
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
                          heatmapPoints.clear();
                          setPlaceType(t.key, context);},
                        dense: true,
                        enabled: true,
                        title: Text(t.translation, style: TextStyle(color: CustomPalette.text[300])),
                        leading: Radio(
                          groupValue: selectedType,
                          value: t.key,
                          onChanged: (key) {
                            heatmapPoints.clear();
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