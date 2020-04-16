import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class CustomCard extends StatelessWidget {
  final Color cardColor = CustomPalette.background[600];
  final Color shadowColor = CustomPalette.background[900];
  final String title;
  CustomCard (this.title);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Center(child: Text(title, style: TextStyle(color: Colors.white))),
        color: cardColor,
      ),

      /*
      decoration: new BoxDecoration(boxShadow: [
        new BoxShadow(
          color: shadowColor,
          blurRadius: 10.0,
          spreadRadius: -5.0
        ),
      ]),
       */

    );
  }
}