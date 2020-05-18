import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pandemia/data/database/models/Favorite.dart';

/// https://stackoverflow.com/questions/30857150/getting-google-maps-link-from-place-id
/// https://github.com/m-wrzr/populartimes
class Parser {
  static Future<dynamic> getPopularTimes(Favorite place) async {
    var file = await getFile(place);
    try {
      var populartimes = parseResponse(file);
      print(populartimes);
      return populartimes;
    } catch (err) {
      print("pas d'affluence trouvée pour ${place.name}");
      return -1;
    }
  }

  static Future<String> getFile (Favorite place) async {
    // String url = "https://www.google.com/maps/place/?q=place_id:$placeId";
    String identifier = place.getIdentifier();
    String url = "https://www.google.de/search?tbm=map&ych=1&h1=en&pb=!4m12!1m3!1d4005.9771522653964!2d-122.42072974863942!3d37.8077459796541!2m3!1f0!2f0!3f0!3m2!1i1125!2i976!4f13.1!7i20!10b1!12m6!2m3!5m1!6e2!20e3!10b1!16b1!19m3!2m2!1i392!2i106!20m61!2m2!1i203!2i100!3m2!2i4!5b1!6m6!1m2!1i86!2i86!1m2!1i408!2i200!7m46!1m3!1e1!2b0!3e3!1m3!1e2!2b1!3e2!1m3!1e2!2b0!3e3!1m3!1e3!2b0!3e3!1m3!1e4!2b0!3e3!1m3!1e8!2b0!3e3!1m3!1e3!2b1!3e2!1m3!1e9!2b1!3e2!1m3!1e10!2b0!3e3!1m3!1e10!2b1!3e2!1m3!1e10!2b0!3e4!2b1!4b1!9b0!22m6!1sa9fVWea_MsX8adX8j8AE%3A1!2zMWk6Mix0OjExODg3LGU6MSxwOmE5ZlZXZWFfTXNYOGFkWDhqOEFFOjE!7e81!12e3!17sa9fVWea_MsX8adX8j8AE%3A564!18e15!24m15!2b1!5m4!2b1!3b1!5b1!6b1!10m1!8e3!17b1!24b1!25b1!26b1!30m1!2b1!36b1!26m3!2m2!1i80!2i92!30m28!1m6!1m2!1i0!2i0!2m2!1i458!2i976!1m6!1m2!1i1075!2i0!2m2!1i1125!2i976!1m6!1m2!1i0!2i0!2m2!1i1125!2i20!1m6!1m2!1i0!2i956!2m2!1i1125!2i976!37m1!1e81!42b1!47m0!49m1!3b1&q=$identifier";
    String encodedUrl = Uri.encodeFull(url);

    print('hitting $encodedUrl');
    var response = await http.get(encodedUrl);
    return response.body;
  }

  static parseResponse (String file) {
    // removing first line
    var responseObject = file.split('\n');
    responseObject.removeAt(0);

    var object = responseObject.join("");
    var jsonObject = json.decode(object);

    return jsonObject[0][1][0][14][84][0];
  }
}