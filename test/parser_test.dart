import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';
import 'package:http/http.dart' as http;
import 'package:pandemia/data/populartimes/payloads/dayResults.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  PopularTimesParser parser;
  final String endpoint = "https://www.google.de/search?tbm=map&ych=1&h1=en&pb=!4m12!1m3!1d4005.9771522653964!2d-122.42072974863942!3d37.8077459796541!2m3!1f0!2f0!3f0!3m2!1i1125!2i976!4f13.1!7i20!10b1!12m6!2m3!5m1!6e2!20e3!10b1!16b1!19m3!2m2!1i392!2i106!20m61!2m2!1i203!2i100!3m2!2i4!5b1!6m6!1m2!1i86!2i86!1m2!1i408!2i200!7m46!1m3!1e1!2b0!3e3!1m3!1e2!2b1!3e2!1m3!1e2!2b0!3e3!1m3!1e3!2b0!3e3!1m3!1e4!2b0!3e3!1m3!1e8!2b0!3e3!1m3!1e3!2b1!3e2!1m3!1e9!2b1!3e2!1m3!1e10!2b0!3e3!1m3!1e10!2b1!3e2!1m3!1e10!2b0!3e4!2b1!4b1!9b0!22m6!1sa9fVWea_MsX8adX8j8AE%3A1!2zMWk6Mix0OjExODg3LGU6MSxwOmE5ZlZXZWFfTXNYOGFkWDhqOEFFOjE!7e81!12e3!17sa9fVWea_MsX8adX8j8AE%3A564!18e15!24m15!2b1!5m4!2b1!3b1!5b1!6b1!10m1!8e3!17b1!24b1!25b1!26b1!30m1!2b1!36b1!26m3!2m2!1i80!2i92!30m28!1m6!1m2!1i0!2i0!2m2!1i458!2i976!1m6!1m2!1i1075!2i0!2m2!1i1125!2i976!1m6!1m2!1i0!2i0!2m2!1i1125!2i20!1m6!1m2!1i0!2i956!2m2!1i1125!2i976!37m1!1e81!42b1!47m0!49m1!3b1&q=";

  test('Checking popular times of a place that have some', () async {
    Favorite placeWithStats = new Favorite(
        name: "E.Leclerc Hyper Paris 19",
        address: "191 Boulevard Macdonald, 75019 Paris, France",
        id: "Chpflfkeiecjegh"
    );
    final String identifier = "E.Leclerc Hyper Paris 19 191 Boulevard Macdonald, 75019 Paris, France";
    expect(identifier, placeWithStats.getIdentifier());

    final _client = MockClient();
    when(_client.get(Uri.encodeFull("$endpoint$identifier")))
      .thenAnswer((_) async {
        String result = await new File('test/result_example.txt').readAsString();
        return http.Response(result, 200, headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        });
      });
    parser = new PopularTimesParser(httpClient: _client);

    var stats = await parser.getPopularTimes(placeWithStats);
    expect(stats.hasData, true);

    Map<int, DayResult> results = stats.stats;
    expect(results.length, 7); // has stats for each weekday

    // on monday, is open from 6am to 11pm
    DayResult mondayStats = results[1];
    expect(mondayStats.times[0][0], 6);
    expect(mondayStats.times[mondayStats.times.length-1][0], 23);

    // checking if each time of the day has associated statistics
    for (List<int> hour in mondayStats.times) {
      expect(hour[0] is int, true);  // time of the day (eg 11 => 11am)
      expect(hour[1] is int, true);  // occupation (eg 56 => 56% full)
    }
  });

  test('Checking popular times of a place that does not have some', () async {
    Favorite placeWithoutStats = new Favorite(
        name: "Cimetière du Père Lachaise",
        address: "16 Rue du Repos, 75020 Paris, France",
        id: "Chdzmdazdkahzdkj"
    );
    final String identifier = "Cimetière du Père Lachaise 16 Rue du Repos, 75020 Paris, France";
    expect(identifier, placeWithoutStats.getIdentifier());

    final _client = MockClient();
    when(_client.get(Uri.encodeFull("$endpoint$identifier")))
        .thenAnswer((_) async {
      String result = await new File('test/no_result_api_response.txt').readAsString();
      return http.Response(result, 200, headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      });
    });
    parser = new PopularTimesParser(httpClient: _client);

    var stats = await parser.getPopularTimes(placeWithoutStats);
    expect(stats.hasData, false);
  });
}
