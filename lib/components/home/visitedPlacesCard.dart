import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/components/home/visit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';
import '../../data/populartimes/parser/parser.dart';
import 'package:pandemia/data/state/MapModel.dart';
import 'package:pandemia/utils/placesMap/SearchZone.dart';
import 'dart:convert';

import '../../data/populartimes/payloads/dayResults.dart';

/// Map card showing places the user visited today.
class VisitedPlacesCard extends StatelessWidget {
  static String _mapStyle;
  static Set<Marker> _markers = {};
  final LatLng _center = const LatLng(50.6311652, 3.0477402);
  static AppDatabase db = new AppDatabase();
  static var result=0.0;
  var res;

  VisitedPlacesCard() {
    marker();
  }

  void findPlaceFromString(String address) async {
    String key = AppModel.apiKey;
    const _host =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    var encoded = Uri.encodeComponent(address);
    // TODO filter place types (prevent registering cities, for example, for they cannot provide popular times)
    final uri = Uri.parse('$_host?input=$encoded&inputtype=textquery'
        '&fields=name,place_id,formatted_address,geometry'
        '&locationbias=circle:467.0@50.68078750377484,3.2189865969121456'
        '&key=$key');
    print('hitting $uri');

    http.Response response = await http.get(uri);
    final responseJson = json.decode(response.body);
    var candidates = responseJson['candidates'];
    if (candidates.length != 0) {
      res = candidates[0]['name'];
    }
  }

  recupDonnees(liste,i,nb,n,r,v) async{
    var name = null;
    print('$name $n $r $v');
    String url =
        "https://www.google.de/search?tbm=map&ych=1&h1=en&pb=!4m12!1m3!1d4005.9771522653964!2d-122.42072974863942!3d37.8077459796541!2m3!1f0!2f0!3f0!3m2!1i1125!2i976!4f13.1!7i20!10b1!12m6!2m3!5m1!6e2!20e3!10b1!16b1!19m3!2m2!1i392!2i106!20m61!2m2!1i203!2i100!3m2!2i4!5b1!6m6!1m2!1i86!2i86!1m2!1i408!2i200!7m46!1m3!1e1!2b0!3e3!1m3!1e2!2b1!3e2!1m3!1e2!2b0!3e3!1m3!1e3!2b0!3e3!1m3!1e4!2b0!3e3!1m3!1e8!2b0!3e3!1m3!1e3!2b1!3e2!1m3!1e9!2b1!3e2!1m3!1e10!2b0!3e3!1m3!1e10!2b1!3e2!1m3!1e10!2b0!3e4!2b1!4b1!9b0!22m6!1sa9fVWea_MsX8adX8j8AE%3A1!2zMWk6Mix0OjExODg3LGU6MSxwOmE5ZlZXZWFfTXNYOGFkWDhqOEFFOjE!7e81!12e3!17sa9fVWea_MsX8adX8j8AE%3A564!18e15!24m15!2b1!5m4!2b1!3b1!5b1!6b1!10m1!8e3!17b1!24b1!25b1!26b1!30m1!2b1!36b1!26m3!2m2!1i80!2i92!30m28!1m6!1m2!1i0!2i0!2m2!1i458!2i976!1m6!1m2!1i1075!2i0!2m2!1i1125!2i976!1m6!1m2!1i0!2i0!2m2!1i1125!2i20!1m6!1m2!1i0!2i956!2m2!1i1125!2i976!37m1!1e81!42b1!47m0!49m1!3b1&q=$name $n $r $v";
    String encodedUrl = Uri.encodeFull(url);
    print(encodedUrl);

    var response = await http.get(encodedUrl);
    var file = response.body;
    PopularTimes stats;
    try {
      stats = Parser.parseResponse(file);
    } catch (err) {
      stats = new PopularTimes(hasData: false);
      print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
    }
    var depart = liste[i].timestamp.hour;
    var arrive = liste[i + nb].timestamp.hour;
    var jour = liste[i].timestamp.weekday;
    var k;

    var dayResult = stats.stats[jour];
    List<int> listResult = [];
    if (dayResult.containsData) {
      for (k = arrive; k <= depart; k++) {
        if (k >= 7) {
          listResult.add(dayResult.times[k - 7][1]);
        }
      }
    }
    var c;
    listResult.forEach((element) => c+=element);
    var moyenne = c/listResult.length;
    return moyenne*nb;
  }

  Future<List<Visit>> conv() async {
    List<Visit> listeVisite = [];
    List<Location> liste = await db.getLocations();
    Placemark old = null;
    Location oldLoc = null;
    int nb = 0;
    int i = liste.length - 1;
    DateTime now = new DateTime.now();
    double moyenne;


    var n;
    var r;
    var v;
    while (i >= 0 && now.difference(liste[i].timestamp).inDays < 1) {
      List<Placemark> placemark = await Geolocator()
          .placemarkFromCoordinates(liste[i].lat, liste[i].lng);
      n = placemark[0].name;
      r = placemark[0].thoroughfare;
      v = placemark[0].locality;


      if (old != null &&
          placemark[0].name == old.name &&
          placemark[0].thoroughfare == old.thoroughfare &&
          placemark[0].locality == old.locality) {
        nb += 1;
      } else {
        if (nb >= 3) {
          listeVisite.add(new Visit(liste[i], nb));
          findPlaceFromString('$n $r $v');
          moyenne = await recupDonnees(liste,i,nb,n,r,v);
          result += moyenne;
        }
          nb = 0;

      }
      old = placemark[0];
      oldLoc = liste[i];
      i = i - 1;
    }
    if (nb >= 3) {
      listeVisite.add(new Visit(oldLoc, nb));
      findPlaceFromString('$n $r $v');
      if(i==-1){
        i=0;
      }
      moyenne=await recupDonnees(liste,i,nb,n,r,v);
      result+=moyenne;
    }
    return listeVisite;
  }

  marker() async {
    List<Visit> visited = await conv();

    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
      int i = 0;
      for (Visit v in visited) {
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(v.visit.lat, v.visit.lng)));
        i = i + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        return GestureDetector(
            onTap: () => model.setTabIndex(1),
            child: Container(
                height: 350,
                margin: const EdgeInsets.all(20),
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CustomPalette.background[900]),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(5.0))),
                        child: new ClipRRect(
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(5.0)),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            heightFactor: 0.3,
                            widthFactor: 2.5,
                            child: Consumer<AppModel>(
                              builder: (context, model, child) => GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: _center,
                                  zoom: 13.75,
                                ),
                                markers: _markers,
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
                        )),
                    Container(
                      child: new Text(
                        FlutterI18n.translate(context, "home_places_title"),
                        style: TextStyle(
                            color: CustomPalette.text[100],
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                      padding: EdgeInsets.all(10.0),
                    ),
                    Container(
                        child: new Text(
                          getPlacesTitle(context),
                          style: TextStyle(
                              color: CustomPalette.text[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 35.0, horizontal: 10.0))
                  ],
                  fit: StackFit.expand,
                )));
      },
    );
  }

  String getPlacesTitle(BuildContext context) {
    int placesCount = 0;
    return "$placesCount " +
        FlutterI18n.translate(context, "word_place") +
        (placesCount > 1 ? 's' : '');
  }
}
