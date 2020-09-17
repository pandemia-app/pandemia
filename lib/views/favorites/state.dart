import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/favorites/FavoritePanel.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/views/favorites/view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// State of the favorite view.
class FavoritesState extends State<FavoritesView> {
  AppDatabase db = new AppDatabase();
  final List<Favorite> _data = new List();
  static bool isRefreshing = false;
  static int loadedPlaces = 0;
  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  /// Called by favorite place panels once they're loaded.
  void panelIsLoaded () {
    if (isRefreshing) {
      loadedPlaces += 1;
    }
    if (loadedPlaces == _data.length) {
      new Future.delayed(const Duration(milliseconds: 1), refreshFinished);
    }
  }

  void refreshFinished () {
    _refreshController.refreshCompleted();
    isRefreshing = false;
    loadedPlaces = 0;
    print("all panes are loaded, refreshing is over");
  }

  void _onRefresh() async{
    isRefreshing = true;
    PopularTimesParser.cache.clear();
    setState(() {});
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted)
      setState((){});
    _refreshController.loadComplete();
  }

  /// Allows the user to remove a favorite place.
  void _showDialog(Favorite item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(FlutterI18n.translate(context, "favorites_removedialog_title")),
          content: new Text("${FlutterI18n.translate(context, "favorites_removedialog_text1")} "
              "${item.name} ${FlutterI18n.translate(context, "favorites_removedialog_text2")}"),
          actions: <Widget>[
            new FlatButton(
              child: new Text(FlutterI18n.translate(context, "favorites_removedialog_cancellabel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(FlutterI18n.translate(context, "favorites_removedialog_removelabel")),
              onPressed: () {
                Navigator.of(context).pop();
                db.removeFavoritePlace(item.id)
                .then((_) {
                  setState(() {
                    _data.removeWhere((i) => i == item);
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Favorite>>(
        future: db.getFavoritePlaces(),
        builder: (context, AsyncSnapshot<List<Favorite>> snapshot) {
          if (!snapshot.hasData || snapshot.data.length == 0) {

            // the user has no registered favorite place yet
            if (snapshot.connectionState == ConnectionState.done) {
              return Center (
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: new Text(
                          FlutterI18n.translate(context, "favorites_none_title"),
                          style: TextStyle(
                              color: CustomPalette.text[100],
                              fontSize: 20,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        padding: EdgeInsets.all(10.0),
                      ),

                      Container(
                          child: new Text(
                            FlutterI18n.translate(context, "favorites_none_subtitle"),
                            style: TextStyle(
                                color: CustomPalette.text[600],
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
                      )
                    ],
                  )
              );
            } else {
              return CircularProgressIndicator();
            }
          }

          // saving places in state
          if (_data.length == 0) {
            _data.clear();
            _data.addAll(snapshot.data);
            print('building ${snapshot.data.length} items');
          }

          return SafeArea(
              child: Scaffold(
                body: SmartRefresher(
                    enablePullDown: true,
                    header: ClassicHeader(
                      idleText: FlutterI18n.translate(context, "favorites_pullrefresh_idle"),
                      releaseText: FlutterI18n.translate(context, "favorites_pullrefresh_release"),
                      refreshingText: FlutterI18n.translate(context, "favorites_pullrefresh_refreshing"),
                      completeText: FlutterI18n.translate(context, "favorites_pullrefresh_complete")),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          child: _buildPanel(),
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                    )
                ),

                backgroundColor: CustomPalette.background[700]
              )
          );
        }
    );
  }

  /// Creates and injects an expansion panel for each favorite place.
  Widget _buildPanel() {
    List<Widget> panels = new List();

    // deploys an expansion panel and closes others
    Function expansionCallback = (int index, bool isExpanded, Favorite place) {
      setState(() {
        for (var i = 0, len = _data.length; i < len; i++) {
          _data[i].isExpanded =
          _data[i].id == place.id ? !place.isExpanded : false;
        }
      });
    };

    // builds a header for all panels with places' name and address
    Function headerBuilder = (BuildContext context, bool isExpanded, Favorite place) {
      return GestureDetector(
          onLongPress: () => _showDialog(place),
          child: Container (
            margin: EdgeInsets.all(0),
            child: ListTile(
              title: Text(place.name, style: TextStyle(color: CustomPalette.text[200])),
              subtitle: Text(place.address,
                style: TextStyle(color: CustomPalette.text[500]),
                overflow: TextOverflow.ellipsis,
                maxLines: isExpanded ? 3 : 1,
              ),
            ),
          )
      );
    };

    // creating an expansion panel for each place
    for (Favorite place in _data) {
      panels.add(
          FavoritePanel(
            place, this._showDialog, expansionCallback, headerBuilder, this
          )
      );
    }

    return Container(
        margin: EdgeInsets.all(0),
        child: Theme(
            data: Theme.of(context).copyWith(
              cardColor: CustomPalette.background[500],
            ),
            child: Column (
              children: panels,
            )
        )
    );
  }
}
