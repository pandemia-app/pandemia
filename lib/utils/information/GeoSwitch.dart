import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeoSwitch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GeoSwitchState();
  }
}

class GeoSwitchState extends State<GeoSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Switch(value: _value, onChanged: (bool newValue) {
      setState(() {
        _value = newValue;
      });
    });
  }
}