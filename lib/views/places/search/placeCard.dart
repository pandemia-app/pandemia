import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import '../../../utils/CustomPalette.dart';

class PlaceCard extends StatefulWidget {
  final Favorite place;
  PlaceCard({this.place});

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.place == null) {
      return new Container ();
    }

    return Container (
      margin: EdgeInsets.all(7),
      color: CustomPalette.background[200],
      child: ListTile(
        title: Text("${widget.place.name}", style: TextStyle(
            color: CustomPalette.text[100],
            fontSize: 20,
            fontWeight: FontWeight.w300
        )
        ),
        subtitle: Text("${widget.place.address}", style: TextStyle(
            color: CustomPalette.text[300],
            fontSize: 16,
            fontWeight: FontWeight.w300
        ),),
        trailing: buildFavButton(widget.place.id),
      ),
    );
  }

  // TODO check if the place is already registered, and display logo accordingly
  Widget buildFavButton (String placeId) {
    return IconButton(
        icon: Icon(Icons.star_border),
        onPressed: () => print("hello")
    );
  }
}