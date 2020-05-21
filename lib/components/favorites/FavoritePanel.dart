import 'package:flutter/cupertino.dart';
import 'package:pandemia/components/favorites/FavoritePanelState.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/views/favorites/state.dart';

/// Widget that represents a favorite place.
class FavoritePanel extends StatefulWidget {
  final Favorite place;
  final Function dialogCallback;
  final Function expansionCallback;
  final Function headerBuilder;
  final FavoritesState state;
  FavoritePanel (this.place, this.dialogCallback, this.expansionCallback, this.headerBuilder, this.state);

  @override
  FavoritePanelState createState() =>
      FavoritePanelState(place, dialogCallback, expansionCallback, headerBuilder, state);
}