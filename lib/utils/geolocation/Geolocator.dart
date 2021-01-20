import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/data/database/models/dataCollect.dart';

class Geolocator {
  static const String _isolateName = "LocatorIsolate";
  static ReceivePort port = ReceivePort();
  static AppDatabase db = new AppDatabase();

  static void launch () {
    init().then((value) {
      BackgroundLocator.registerLocationUpdate(
        Geolocator.callback,
        autoStop: false,
        androidSettings: AndroidSettings (
          androidNotificationSettings: AndroidNotificationSettings(
            notificationChannelName: 'Pandemia location tracking',
            notificationTitle: "Registering locations",
            notificationBigMsg: "Tap to check your virus exposition.",
            notificationIcon: "ic_virus_outline_black",
          ),
          wakeLockTime: 20,
          interval: 60,
        ),
        iosSettings: IOSSettings (
          showsBackgroundLocationIndicator: true
        )
      );
    });
  }

  static Future<void> init () async {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) async {});
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
    DateTime timestamp = new DateTime.now();
    AppDatabase db = new AppDatabase();
    await db.insertLocation(
        new Location(
            lat: locationDto.latitude,
            lng: locationDto.longitude,
            timestamp: timestamp));
    print('received new location at $timestamp, location : $locationDto');
    var dataCollect = DataCollect();
    dataCollect.conv();
  }

  static void stop () {
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
  }
}