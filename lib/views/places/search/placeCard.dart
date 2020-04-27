import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/CustomPalette.dart';

class PlaceCard extends StatefulWidget {
  final String name;
  final String address;
  PlaceCard({this.name, this.address});

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.name == null || widget.address == null) {
      return new Container ();
    }

    return Container (
      margin: EdgeInsets.all(7),
      color: CustomPalette.background[200],
      child: ListTile(
        title: Text("${widget.name}", style: TextStyle(
            color: CustomPalette.text[100],
            fontSize: 20,
            fontWeight: FontWeight.w300
        )
        ),
        subtitle: Text("${widget.address}", style: TextStyle(
            color: CustomPalette.text[300],
            fontSize: 16,
            fontWeight: FontWeight.w300
        ),),
        trailing: Icon(Icons.star_border),
      ),
    );
  }
}