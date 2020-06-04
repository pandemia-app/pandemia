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
    setState(() {
      _value = !_value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch(value: _value, onChanged: (bool newValue) {
      setState(() {
        _value = newValue;
      });
    });
  }
}