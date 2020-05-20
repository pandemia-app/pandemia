import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser.dart';
import 'package:pandemia/data/populartimes/populartimes.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/views/favorites/view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritesState extends State<FavoritesView> {
  AppDatabase db = new AppDatabase();
  final List<Favorite> _data = new List();
  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 2000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted)
      setState((){});
    _refreshController.loadComplete();
  }

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
          FutureBuilder<dynamic>(
              future: Parser.getPopularTimes(place),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                // loading data
                if (!snapshot.hasData) {
                  return Container (
                    padding: EdgeInsets.only(bottom: 20),
                    child: ExpansionPanelList (
                      expansionCallback: (index, isExpanded) => expansionCallback(index, isExpanded, place),
                      children: [ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: place.isExpanded,
                          headerBuilder: (context, isExpanded) => headerBuilder(context, isExpanded, place),
                          body: Container (
                            height: 200,
                            color: CustomPalette.background[600],
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                      )],
                    )
                  );
                }

                // no popular times to display
                if (snapshot.data == -1) {
                  return Container (
                    padding: EdgeInsets.only(bottom: 20),
                    child: ExpansionPanelList (
                      expansionCallback: (index, isExpanded) => expansionCallback(index, isExpanded, place),
                      children: [ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: place.isExpanded,
                          headerBuilder: (context, isExpanded) => headerBuilder(context, isExpanded, place),
                          body: Container(
                            child: Text(
                              FlutterI18n.translate(context, "favorites_nopopulartimes"),
                              style: TextStyle(
                                  color: CustomPalette.text[600],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                          )
                      )],
                    )
                  );
                }

                // building stats carousel items
                PopularTimes data = snapshot.data;
                List<Widget> statCards = [];

                for (var weekday in data.getOrderedKeys()) {
                  var weekstats = data.stats[weekday];
                  List<Widget> widgets = [
                    SimpleBarChart.fromPopularTimes ( weekstats.times ),
                    Container (
                      padding: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        FlutterI18n.translate(context, "day_$weekday"),
                        style: TextStyle(
                            color: CustomPalette.text[500],
                            fontSize: 18,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                    )
                  ];
                  if (!weekstats.containsData) {
                    widgets.add(
                      Center (
                        child: Text(
                          FlutterI18n.translate(context, "favorites_placeclosed"),
                          style: TextStyle(
                              color: CustomPalette.text[500],
                              fontSize: 18,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      )
                    );
                  }

                  statCards.add(
                      Stack (
                        children: widgets,
                      )
                  );
                }

                return Container (
                  padding: EdgeInsets.only(bottom: 20),
                  child: ExpansionPanelList (
                    expansionCallback: (index, isExpanded) => expansionCallback(index, isExpanded, place),
                    children: [ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: place.isExpanded,
                        headerBuilder: (context, isExpanded) => headerBuilder(context, isExpanded, place),
                        body: Card(
                          margin: EdgeInsets.all(0),
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ) ,
                          borderOnForeground: true,
                          color: CustomPalette.background[600],
                          child: Container (
                              height: 200,
                              child: Stack(
                                children: <Widget>[
                                  CarouselSlider(
                                    options: CarouselOptions(
                                        enableInfiniteScroll: true,
                                        enlargeCenterPage: true,
                                        initialPage: DateTime.now().weekday-1,
                                        viewportFraction: 1,
                                        height: 200
                                    ),
                                    items: statCards,
                                  ),

                                  Align(
                                    child: GestureDetector(
                                      child: IconTheme(
                                        data: new IconThemeData(
                                            color: CustomPalette.background[400]),
                                        child: new Icon(Icons.arrow_back_ios),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),

                                  Align(
                                    child: GestureDetector(
                                      child: IconTheme(
                                        data: new IconThemeData(
                                            color: CustomPalette.background[400]),
                                        child: new Icon(Icons.arrow_forward_ios),
                                      ),
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                ],
                              )
                          ),
                        )
                    )],
                  ),
                );
              }
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
