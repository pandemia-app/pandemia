import 'package:http/http.dart' as http;

/// https://stackoverflow.com/questions/30857150/getting-google-maps-link-from-place-id
class Parser {
  static Future<int> getPopularTimes(String placeId) async {
    var html = await getHTML(placeId);
    return parseHTML(html);
  }

  static Future<String> getHTML (String placeId) async {
    String url = "https://www.google.com/maps/place/?q=place_id:$placeId";
    var response = await http.get(url);
    print(response.statusCode);
    print(response.body);
    return "";
  }

  static int parseHTML(String html) {
    return 0;
  }
}