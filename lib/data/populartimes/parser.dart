import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

/// https://stackoverflow.com/questions/30857150/getting-google-maps-link-from-place-id
class Parser {
  static Future<int> getPopularTimes(String placeId) async {
    var html = await getHTML(placeId);
    return parseHTML(html);
  }

  static Future<String> getHTML (String placeId) async {
    String url = "https://www.google.com/maps/place/?q=place_id:$placeId";
    print(url);
    var response = await http.get(url);
    return response.body;
  }

  static int parseHTML(String html) {
    var document = parse(html);
    var tags = document.querySelectorAll('[aria-label]');
    print(tags.length);
    return 0;
  }
}