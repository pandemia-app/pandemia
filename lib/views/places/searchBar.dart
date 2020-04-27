import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pandemia/utils/secret/Secret.dart';
import 'package:pandemia/utils/secret/SecretLoader.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container (
        margin: EdgeInsets.all(10),
        child: TextField(
            style: TextStyle(color: CustomPalette.text[400]),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: CustomPalette.text[400]),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: CustomPalette.text[400]),
                  ),
                  labelStyle: TextStyle(color: CustomPalette.text[400]),
                  labelText: 'Search place...',
              ),

          onSubmitted: (s) => findPlaceFromString(s),
          )
      ),
    );
  }

  void findPlaceFromString (String address) async {
    Secret secret = await SecretLoader(secretPath: "secrets.json").load();
    const _host = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';
    var encoded = Uri.encodeComponent(address);
    final uri = Uri.parse('$_host?input=$encoded&inputtype=textquery&fields=name,formatted_address,geometry&key=${secret.apiKey}');
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
        print('going to ${candidates[0]['geometry']['location']}');
        break;
      default:
        // TODO display list of addresses
        break;
    }
  }

}