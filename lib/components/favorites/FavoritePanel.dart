import 'package:flutter/cupertino.dart';
import 'package:pandemia/components/favorites/FavoritePanelState.dart';
import 'package:pandemia/data/database/models/Favorite.dart';

class FavoritePanel extends StatefulWidget {
  final Favorite place;
  final Function dialogCallback;
  final Function expansionCallback;
  final Function headerBuilder;
  FavoritePanel (this.place, this.dialogCallback, this.expansionCallback, this.headerBuilder);

  @override
  FavoritePanelState createState() =>
      FavoritePanelState(place, dialogCallback, expansionCallback, headerBuilder);
}