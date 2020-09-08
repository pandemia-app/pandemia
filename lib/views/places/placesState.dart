import 'dart:convert';
import 'dart:io';
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
import 'package:pandemia/data/populartimes/payloads/PlacesAPIResult.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/GeoComputer.dart';
import 'package:pandemia/utils/PlacesCounter.dart';
import 'package:pandemia/utils/Preferences.dart';
import 'package:pandemia/utils/placesMap/PlacesMapController.dart';
import 'package:pandemia/utils/placesMap/SearchZone.dart';
import 'package:pandemia/views/places/places.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PlacesState extends State<PlacesView> {
  PlacesMapController _controller;
  GoogleMapController _mapController;
  String _mapStyle;
  final searchBar = new SearchBar();
  Favorite fPlace;
  String selectedType = "";
  Map<String, WeightedLatLng> heatmapPoints = <String, WeightedLatLng>{};
  PopularityPointsCache cache = new PopularityPointsCache();
  bool loadingPlaces = true;
  double zoomLevel = 0;
  String _defaultPlaceType = "supermarket";


  void _onMapCreated(GoogleMapController controller, BuildContext context) async {
    await Preferences.init();
    _controller = new PlacesMapController(controller: controller);
    _mapController = controller;
    controller.setMapStyle(_mapStyle);
    searchBar.mapController = controller;
    searchBar.callback = (dynamic place) {
      setState(() {
        fPlace =
            Favorite(address: place['formatted_address'], name: place['name'],
            id: place['place_id']);
      });
    };
    searchBar.closeCallback = () {
      setState(() {
        fPlace = null;
      });
    };
    _controller.initCamera();
    setPlaceType(
        Preferences.storage.getString("favoritePlaceType") != null ? Preferences.storage.getString("favoritePlaceType") : _defaultPlaceType,
        context);
  }

  Future<List<PlacesAPIResult>> getNearbyPlacesFromPlacesAPI (CircularSearchZone viewport) async {
    String key = AppModel.apiKey;
    const host = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final uri = Uri.parse('$host?location=${viewport.center.latitude},${viewport.center.longitude}&radius=${viewport.radius}&type=$selectedType&key=$key');
    print('hitting $uri');

    http.Response response = await http.get (uri);
    final responseJson = json.decode(response.body);
    return (responseJson['results'] as List<dynamic>)
        .map((e) => PlacesAPIResult.fromJSON(e)
    ).toList();
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
    if (_controller.controller == null || selectedType == "") return;
    print('getting all places in viewport');

    CircularSearchZone viewport = await _controller.getCurrentSearchZone();
    if (!viewport.isValid()) {
      print('aborting');
      return;
    }

    // checking maximum distance
    if (viewport.radius > 50000) {
      showSearchZoneTooBigToast();
      return;
    }

    setState(() {
      loadingPlaces = true;
    });

    List<PlacesAPIResult> results = await getNearbyPlacesFromPlacesAPI(viewport);

    // display a message if no results were found
    if (results.length == 0)
      showNoResultsToast();
    else
      createHeatmapPoints(results);
  }

  void createHeatmapPoints (List<PlacesAPIResult> results) {
    // this counter allows to adds all points at once, when all places data have
    // been loaded.
    PlacesCounter counter = new PlacesCounter();
    counter.setPlacesCount(results.length);
    Map<String, WeightedLatLng> pointsCache = <String, WeightedLatLng>{};

    // adds a marker for each place
    for (var result in results) {
      pointsCache[result.placeId] =
          WeightedLatLng( point: result.location );

      // refresh data with popularity stats
      Parser.getPopularTimes(Favorite.fromPlacesAPIResult(result)).then((value) {
        if (value.hasData) {
          pointsCache.addAll(
              cache.getPoints(result, value.currentPopularity, zoomLevel)
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
  void initState() {
    super.initState();
    typeSelector = PlaceTypeSheet(onTypeUpdated: (String key) {
      heatmapPoints.clear();
      Preferences.storage.setString('favoritePlaceType', key);
      setPlaceType(key, context);
    }, context: context);

    searchBar.fatherContext = context;
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Stack (
          fit: StackFit.passthrough,
          children: <Widget>[
            GoogleMap(
              onCameraMove: (position) {
                zoomLevel = position.zoom;
                Preferences.storage.setDouble('favoriteMapLat', position.target.latitude);
                Preferences.storage.setDouble('favoriteMapLng', position.target.longitude);
                Preferences.storage.setDouble('favoriteMapZoom', position.zoom);
              },
              onMapCreated: (controller) => _onMapCreated(controller, context),
              onCameraIdle: () => getAllPlacesInViewport(context),
              heatmaps: Set<Heatmap>.of([
                Heatmap (
                  heatmapId: HeatmapId(DateTime.now().toIso8601String()),
                  radius: Platform.isIOS ? 100 : 30,
                  opacity: Platform.isIOS ? 1 : 0.8,
                  gradient: HeatmapGradient(colors: [Colors.green, Colors.red],
                      startPoints: Platform.isIOS ? [0.05, 0.08] : [0.2, 0.8]),
                  points: heatmapPoints.values.length == 0 ? [WeightedLatLng(point: LatLng(0, 0))] : heatmapPoints.values.toList()
                )
              ]),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              initialCameraPosition: CameraPosition(
                target: PlacesMapController.defaultCenter,
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
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: Builder(
                builder: (BuildContext _context) {
                  if (selectedType == "") {
                    return Container();
                  } else {
                    return Container (
                      child: Text(
                        FlutterI18n.translate(context, "places_typepicker_type_$selectedType"),
                        style: TextStyle(
                            color: CustomPalette.text[600],
                            fontSize: 20,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      padding: EdgeInsets.only(left: 5, bottom: 32),
                    );
                  }
                },
              ),
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

  void showSearchZoneTooBigToast() {
    Fluttertoast.showToast(
        msg: FlutterI18n.translate(context, "places_searchzone_toobig"),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        fontSize: 16.0
    );
    setState(() {
      loadingPlaces = false;
    });
  }

  void showNoResultsToast() {
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
}