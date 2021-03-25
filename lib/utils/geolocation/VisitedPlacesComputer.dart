import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pandemia/components/home/visit.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart' as Local;
import 'package:pandemia/data/populartimes/parser/parser.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';
import 'package:http/http.dart' as http;
import 'package:pandemia/data/state/AppModel.dart';
import 'package:provider/provider.dart';

class VisitedPlacesComputer {
  static BuildContext _context;
  static AppDatabase db = new AppDatabase();
  static double _currentExposureRate = 0.0;
  static DateTime _lastNotificationSendingTime;

  static init (BuildContext context) {
    _context = context;
  }

  static Future<num> getCurrentExposureRate () async {
    await computeVisitedPlaces();
    return _currentExposureRate;
  }

  static computeVisitedPlaces () async {
    print("COMPUTING PLACES");
    List<Visit> visited = await conv(_context);
    print('${visited.length} visited places found.');

    List<Marker> _markers = [];

    visited.asMap().forEach((key, value) {
      _markers.add(Marker(
          markerId: MarkerId(key.toString()),
          position: LatLng(value.visit.lat, value.visit.lng)));
    });

    Provider.of<AppModel>(_context, listen: false).setVisitedPlacesMarkers(_markers);
  }

  /*
  *methode generant l'affichage de la notification a partir d'une certaine condition et modifie le taux d'exposition
  * retourne la liste des lieux visite

   */
  static Future<List<Visit>> conv (BuildContext context) async {
    List<Visit> listeVisite = [];
    List<Local.Location> liste = await db.getLocations();
    Placemark old;
    Local.Location oldLoc;
    int nb = 0;
    int i = liste.length - 1;
    DateTime now = new DateTime.now();
    double moyenne;

    var n;
    var r;
    var v;
    _currentExposureRate = 0;

    while (i >= 0 && now.difference(liste[i].timestamp).inDays < 1) {
      List<Placemark> placemark = await
      placemarkFromCoordinates(liste[i].lat, liste[i].lng);
      n = placemark[0].name;
      r = placemark[0].thoroughfare;
      v = placemark[0].locality;

      if (old != null &&
          n == old.name &&
          r == old.thoroughfare &&
          v == old.locality) {
        nb += 1;
      } else {
        if (nb >= 3) {
          listeVisite.add(new Visit(liste[i + 1], nb));
          moyenne = await recupDonnees(
              liste, i + 1, nb, old.name, old.thoroughfare, old.locality);
          _currentExposureRate += moyenne;
        }
        nb = 0;
      }
      old = placemark[0];
      oldLoc = liste[i];
      i = i - 1;
    }
    if (nb >= 3) {
      listeVisite.add(new Visit(oldLoc, nb));
      i = i + 1;
      if (i == -1) {
        i = 0;
      }

      moyenne = await recupDonnees(liste, i, nb, n, r, v);
      _currentExposureRate += moyenne;
    }
    if (_currentExposureRate >= 50) {
      if (_lastNotificationSendingTime == null || now.difference(_lastNotificationSendingTime).inHours >= 2) {
        _showNotificationWithDefaultSound (
            _currentExposureRate < 100 ? _currentExposureRate.round() : 100, context);
        _lastNotificationSendingTime = now;
      }
    }
    return listeVisite;
  }


  /*
  *methode permettant de recuperer des donnees de flux de personnes a partir d'une adresse
  *retourne une valeur representant le taux d'exposition
   */
  static recupDonnees(liste, i, nb, n, r, v) async {
    var name;
    //url permettant de recuperer ces donnees au format JSON
    String url =
        "https://www.google.de/search?tbm=map&ych=1&h1=en&pb=!4m12!1m3!1d4005.9771522653964!2d-122.42072974863942!3d37.8077459796541!2m3!1f0!2f0!3f0!3m2!1i1125!2i976!4f13.1!7i20!10b1!12m6!2m3!5m1!6e2!20e3!10b1!16b1!19m3!2m2!1i392!2i106!20m61!2m2!1i203!2i100!3m2!2i4!5b1!6m6!1m2!1i86!2i86!1m2!1i408!2i200!7m46!1m3!1e1!2b0!3e3!1m3!1e2!2b1!3e2!1m3!1e2!2b0!3e3!1m3!1e3!2b0!3e3!1m3!1e4!2b0!3e3!1m3!1e8!2b0!3e3!1m3!1e3!2b1!3e2!1m3!1e9!2b1!3e2!1m3!1e10!2b0!3e3!1m3!1e10!2b1!3e2!1m3!1e10!2b0!3e4!2b1!4b1!9b0!22m6!1sa9fVWea_MsX8adX8j8AE%3A1!2zMWk6Mix0OjExODg3LGU6MSxwOmE5ZlZXZWFfTXNYOGFkWDhqOEFFOjE!7e81!12e3!17sa9fVWea_MsX8adX8j8AE%3A564!18e15!24m15!2b1!5m4!2b1!3b1!5b1!6b1!10m1!8e3!17b1!24b1!25b1!26b1!30m1!2b1!36b1!26m3!2m2!1i80!2i92!30m28!1m6!1m2!1i0!2i0!2m2!1i458!2i976!1m6!1m2!1i1075!2i0!2m2!1i1125!2i976!1m6!1m2!1i0!2i0!2m2!1i1125!2i20!1m6!1m2!1i0!2i956!2m2!1i1125!2i976!37m1!1e81!42b1!47m0!49m1!3b1&q=$name $n $r $v";
    String encodedUrl = Uri.encodeFull(url);

    var response = await http.get(encodedUrl);
    var file = response.body;
    PopularTimes stats;
    try {
      stats = Parser.parseResponse(file);

      var arrive = liste[i].timestamp.hour;
      var depart = liste[i + nb].timestamp.hour;
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
      var c = 0;
      listResult.forEach((element) => c += element);
      var moyenne = c / listResult.length;
      //
      return moyenne * nb * 0.125;
    } catch (err) {
      stats = new PopularTimes(hasData: false);
      return 0.0;
    }
  }


  //methode permettant de creer une notification
  static Future _showNotificationWithDefaultSound(taux, BuildContext context) async {
    FlutterLocalNotificationsPlugin flip =
    new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_virus_outline_black');
    // ignore: non_constant_identifier_names
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    // Show a notification after every 15 minute with the first
    // appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'pandemia_alerts_channel',
        FlutterI18n.translate(context, "exposition_notification_channel_name"),
        FlutterI18n.translate(context, "exposition_notification_channel_description"),
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    // initialise channel platform for both Android and iOS device.
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    var texte = FlutterI18n.translate(context, "exposition_notification_text") + ' ${taux.toString()}%!';
    await flip.show(0, FlutterI18n.translate(context, "exposition_notification_title"), texte, platformChannelSpecifics,
        payload: 'Default_Sound');
  }
}