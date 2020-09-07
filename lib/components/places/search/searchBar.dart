import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Allows users to search for places from words.
// ignore: must_be_immutable
class SearchBar extends StatelessWidget {
  GoogleMapController mapController;
  final TextEditingController _controller = new TextEditingController();
  BuildContext fatherContext;
  Function closeCallback;
  Function callback;
  SearchBar ({this.mapController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container (
        margin: EdgeInsets.all(10),
        child: TextField(
          controller: _controller,
            style: TextStyle(color: CustomPalette.text[400]),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 50)).then((_) {
                      _controller.clear();
                      FocusScope.of(context).unfocus();
                      closeCallback();
                    });
                    },
                  icon: Icon(Icons.clear, color: CustomPalette.text[400]),
                ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: CustomPalette.text[400]),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: CustomPalette.text[400]),
                  ),
                  labelStyle: TextStyle(color: CustomPalette.text[400]),
                  labelText: FlutterI18n.translate(fatherContext, "places_searchbar_label"),
              ),

          onSubmitted: (s) => findPlaceFromString(s),
          )
      ),
    );
  }

  /// Requests information from Google Places API to find place and associated
  /// information.
  void findPlaceFromString (String address) async {
    String key = AppModel.apiKey;
    const _host = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    var encoded = Uri.encodeComponent(address);
    // TODO filter place types (prevent registering cities, for example, for they cannot provide popular times)
    final uri = Uri.parse('$_host?input=$encoded&inputtype=textquery&fields=name,place_id,formatted_address,geometry&key=$key');
    print('hitting $uri');

    http.Response response = await http.get (uri);
    final responseJson = json.decode(response.body);
    var candidates = responseJson['candidates'];

    switch (candidates.length) {
      case 0:
        // TODO display error message
        print('no matching place found');
        break;
      case 1:
        var place = candidates[0];
        var location =
          new LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng']
          );
        var viewport = place['geometry']['viewport'];
        print('going to $location');
        mapController.animateCamera(
            CameraUpdate.newLatLng(location));
        mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
                new LatLngBounds(
                    southwest: new LatLng(
                        viewport['southwest']['lat'], viewport['southwest']['lng']),
                    northeast: new LatLng(
                        viewport['northeast']['lat'], viewport['northeast']['lng']))
                , 0));
        callback(place);
        break;
      default:
        // TODO display list of addresses
        break;
    }
  }

}