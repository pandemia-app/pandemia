import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/CustomPalette.dart';

class PlaceCard extends StatelessWidget {
  String name;
  String address;
  PlaceCard({this.name, this.address});

  @override
  Widget build(BuildContext context) {
    if (name == null || address == null) {
      return new Container ();
    }

    return Container (
      margin: EdgeInsets.all(7),
      color: CustomPalette.background[200],
      child: ListTile(
        title: Text("$name", style: TextStyle(
            color: CustomPalette.text[100],
            fontSize: 20,
            fontWeight: FontWeight.w300
        )
        ),
        subtitle: Text("$address", style: TextStyle(
            color: CustomPalette.text[300],
            fontSize: 16,
            fontWeight: FontWeight.w300
        ),),
        trailing: Icon(Icons.star_border),
      ),
    );
  }
}