import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/parser/parser.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/utils/charts/popularityChart.dart';
import 'package:pandemia/views/favorites/state.dart';
import 'FavoritePanel.dart';

class FavoritePanelState extends State<FavoritePanel> {
  final Favorite place;
  final Function dialogCallback;
  final Function expansionCallback;
  final Function headerBuilder;
  Future<PopularTimes> future;
  FavoritePanelState(this.place, this.dialogCallback, this.expansionCallback, this.headerBuilder);

  @override
  void initState () {
    future = Parser.getPopularTimes(place);
    super.initState();
  }

  @override
  Widget build (BuildContext context) {
    // fetching data when pulling-to-refresh
    if (FavoritesState.isRefreshing) {
      future = Parser.getPopularTimes(place);
    }

    return FutureBuilder (
      future: future,
      builder: (context, snapshot) {
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

        PopularTimes times = snapshot.data;

        // no popular times to display
        if (!times.hasData) {
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

        // building times carousel items
        List<Widget> statCards = [];

        for (var weekday in times.getOrderedKeys()) {
          var weekstats = times.stats[weekday];
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
                headerBuilder: (context, isExpanded) => GestureDetector(
                    onLongPress: () => dialogCallback(place),
                    child: Container (
                      margin: EdgeInsets.all(0),
                      child: ListTile(
                        title: Text(place.name, style: TextStyle(color: CustomPalette.text[200])),
                        subtitle: Text(place.address,
                          style: TextStyle(color: CustomPalette.text[500]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: isExpanded ? 3 : 1,
                        ),
                        leading: PopularityChart.fromRate(times.currentPopularity),
                      ),
                    )
                ),
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
    );
  }
}