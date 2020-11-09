import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pandemia/utils/geolocation/Geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// List tile allowing the user to update its location policy.
class GeoTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GeoTileState();
  }
}

class GeoTileState extends State<GeoTile> {
  bool _value = false;
  BuildContext _context;

  @override
  void initState() {
    Permission.locationAlways.status.then((value) {
      setState(() {
        _value = value.isGranted;
      });
    });
    super.initState();
  }

  void _setNewValue (bool value) {
    setState(() {
      _value = value;
    });
    _checkPermissions();
  }

  void _checkPermissions () async {
    // requesting the location permission
    if (_value) {
      var permissionRequest = await Permission.locationAlways.request();
      if (!permissionRequest.isGranted) {
        if (permissionRequest.isPermanentlyDenied) {
          Fluttertoast.showToast(
              msg: FlutterI18n.translate(_context, "home_info_location_permanentlydenied"),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 4,
              fontSize: 16.0
          );
          Timer(Duration(seconds: 2), () => openAppSettings());
        }
        setState(() {
          _value = false;
        });
      } else {
        Geolocator.launch();
      }

    // removing the location permission
    } else {
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(_context, "home_info_location_removepermission"),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          fontSize: 16.0
      );
      Timer(Duration(seconds: 2), () => openAppSettings());
      Geolocator.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return ListTile(
      onTap: () => _setNewValue(!_value),
      leading: new Icon(Icons.location_on),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: new Text(
          FlutterI18n.translate(context, "home_info_location_title")
      ),
      subtitle: Text(
          FlutterI18n.translate(context, "home_info_location_text")
      ),
      trailing: Switch(value: _value, onChanged: (bool newValue) => _setNewValue(newValue)),
    );
  }
}