import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:provider/provider.dart';
import '../../../utils/CustomPalette.dart';

class PlaceCard extends StatefulWidget {
  final Favorite place;
  PlaceCard({this.place});

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  IconData icon = Icons.star_border;

  @override
  Widget build(BuildContext context) {
    if (widget.place == null) {
      return new Container ();
    }

    isPlaceRegistered(widget.place.id).then((value) {
      setState(() {
        icon = value == true ? Icons.star : Icons.star_border;
      });
    });

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
        trailing: buildFavButton(widget.place),
      ),
    );
  }

  Future<bool> isPlaceRegistered (String placeId) async {
    return await Provider.of<AppModel>(context, listen: false)
        .database.isPlaceRegistered(placeId);
  }

  Widget buildFavButton (Favorite place) {
    return IconButton(
        icon: Icon(icon),
        onPressed: () async {
          if (await isPlaceRegistered(place.id)) {
            Provider.of<AppModel>(context, listen: false)
                .database.removeFavoritePlace(place.id).then((_) {
              setState(() {
                icon = Icons.star_border;
              });
            });
          } else {
            Provider.of<AppModel>(context, listen: false)
                .database.insertFavoritePlace(place).then((_) {
                    setState(() {
                      icon = Icons.star;
                    });
              });
          }
        }

    );
  }
}