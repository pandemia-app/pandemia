import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Location.dart';
import 'package:pandemia/data/database/models/dataCollect.dart';

///provide a cross-platform API for generic location
class Geolocator {
  static const String _isolateName = "LocatorIsolate";
  static ReceivePort port = ReceivePort();
  static AppDatabase db = new AppDatabase();
  static BuildContext _context;
  static bool _initialized = false;

  static void launch (BuildContext context) {
    if (_initialized) return;

    _context = context;

    init().then((value) {
      _initialized = true;
      BackgroundLocator.registerLocationUpdate(
        Geolocator.callback,
        autoStop: false,
        androidSettings: AndroidSettings (
          androidNotificationSettings: AndroidNotificationSettings(
            notificationChannelName: FlutterI18n.translate(_context, "location_notification_channel_name"),
            notificationTitle: FlutterI18n.translate(_context, "location_notification_title"),
            notificationBigMsg: FlutterI18n.translate(_context, "location_notification_text"),
            notificationIcon: "ic_virus_outline_black",
          ),
          wakeLockTime: 20,
          interval: 60,
        ),
        iosSettings: IOSSettings (
          showsBackgroundLocationIndicator: true,
          accuracy: LocationAccuracy.HIGH,
          distanceFilter: 0,
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
  }

  static void stop () {
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
  }
}