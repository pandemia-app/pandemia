import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GeoSwitch extends StatefulWidget {
  final GeoSwitchState _state = GeoSwitchState();
  @override
  State<StatefulWidget> createState() {
    _state.initSwitchState();
    return _state;
  }

  void toggle () {
    _state.toggle();
  }
}

class GeoSwitchState extends State<GeoSwitch> {
  bool _value = false;

  void initSwitchState () async {
    var status = await Permission.location.status;
    setState(() {
      _value = status.isGranted;
    });
  }

  void toggle () {
    _setNewValue(!_value);
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
    return Switch(value: _value, onChanged: (bool newValue) => _setNewValue(newValue));
  }
}