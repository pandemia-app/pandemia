import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/components/places/search/placeCard.dart';
import 'package:pandemia/components/places/search/searchBar.dart';
import 'package:pandemia/components/places/type/PlaceTypeSheet.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/cache/PopularityPointsCache.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';
import 'package:pandemia/data/state/AppModel.dart';
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
  PopularityPointsCache cache = new PopularityPointsCache();
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

  dynamic getNearbyPlacesFromPlacesAPI (LatLng middle, double radius) async {
    String key = AppModel.apiKey;
    const host = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final uri = Uri.parse('$host?location=${middle.latitude},${middle.longitude}&radius=$radius&type=$selectedType&key=$key');
    print('hitting $uri');

    http.Response response = await http.get (uri);
    final responseJson = json.decode(response.body);
    return responseJson['results'];
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
    GeoComputer computer = new GeoComputer();
    LatLng middle = computer.getBoundsCenterLocation(bounds);
    double radius = computer.getSearchRadius(bounds);

    // aborting if distance computation failed
    if (middle.longitude == 0.0 && middle.latitude == 0.0 || radius == 0.0) {
      print('aborting');
      return;
    }

    // checking maximum distance
    if (radius > 50000) {
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

    dynamic results = await getNearbyPlacesFromPlacesAPI(middle, radius);

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
      Parser.getPopularTimes(new Favorite(name: result['name'], address: result['vicinity'], id: result['place_id'])).then((value) {
        if (value.hasData) {
          pointsCache.addAll(
            cache.getPoints(
                result['id'],
                LatLng(
                  result['geometry']['location']['lat'],
                  result['geometry']['location']['lng'],
                ),
                value.currentPopularity, zoomLevel)
          );
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

  PlaceTypeSheet typeSelector;

  @override
  Widget build(BuildContext context) {
    typeSelector = PlaceTypeSheet(onTypeUpdated: (String key) {
      heatmapPoints.clear();
      setPlaceType(key, context);
    }, context: context);

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
              child: Column (
                children: <Widget>[
                  searchBar,
                  PlaceCard(place: fPlace, mainContext: context)
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility (
                visible: loadingPlaces,
                child: LinearProgressIndicator(),
              )
            )
          ],
        ),

        floatingActionButton: FloatingActionButton (
          onPressed: () => typeSelector.show(selectedType),
          child: Icon(Icons.filter_list),
        ),
      ),
    );
  }
}