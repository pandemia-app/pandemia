import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  @override
  void initState() {
    Permission.location.status.then((value) {
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

  void _checkPermissions () async { }

  @override
  Widget build(BuildContext context) {
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