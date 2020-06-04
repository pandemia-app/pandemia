import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeoSwitch extends StatefulWidget {
  final GeoSwitchState _state = GeoSwitchState();
  @override
  State<StatefulWidget> createState() {
    return _state;
  }

  void toggle () {
    _state.toggle();
  }
}

class GeoSwitchState extends State<GeoSwitch> {
  bool _value = false;

  void toggle () {
    _setNewValue(!_value);
  }

  void _setNewValue (bool value) {
    setState(() {
      _value = value;
    });
    _checkPermissions();
  }

  void _checkPermissions () {

  }

  @override
  Widget build(BuildContext context) {
    return Switch(value: _value, onChanged: (bool newValue) => _setNewValue(newValue));
  }
}