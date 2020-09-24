import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:provider/provider.dart';

/// Displays information about a selected place.
/// Allows the user to register/unregister a place from his favorite ones.
class PlaceCard extends StatefulWidget {
  final Favorite place;
  final BuildContext mainContext;
  PlaceCard({this.place, this.mainContext});

  @override
  _PlaceCardState createState() => _PlaceCardState(mainContext: mainContext);
}

class _PlaceCardState extends State<PlaceCard> {
  _PlaceCardState({this.mainContext});
  IconData icon = Icons.star_border;
  BuildContext mainContext;

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
        trailing: buildFavButton(widget.place, context),
      ),
    );
  }

  Future<bool> isPlaceRegistered (String placeId) async {
    return await Provider.of<AppModel>(context, listen: false)
        .database.isPlaceRegistered(placeId);
  }

  /// Builds the button allowing the user to add/remove a place to his favorites.
  Widget buildFavButton (Favorite place, BuildContext context) {
    return IconButton(
        icon: Icon(icon),
        onPressed: () async {
          if (await isPlaceRegistered(place.id)) {
            Provider.of<AppModel>(mainContext, listen: false)
                .database.removeFavoritePlace(place.id).then((_) {
              Fluttertoast.showToast(
                  msg: FlutterI18n.translate(mainContext, "places_place_removed_toast"),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0
              );
              setState(() {
                icon = Icons.star_border;
              });
            });
          } else {
            Provider.of<AppModel>(mainContext, listen: false)
                .database.insertFavoritePlace(place).then((_) {
              Fluttertoast.showToast(
                  msg: FlutterI18n.translate(mainContext, "places_place_added_toast"),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  fontSize: 16.0
              );
                    setState(() {
                      icon = Icons.star;
                    });
              });
          }
        }

    );
  }
}