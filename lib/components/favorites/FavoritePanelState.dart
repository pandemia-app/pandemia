import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/data/populartimes/payloads/populartimes.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/utils/charts/popularityChart.dart';
import 'package:pandemia/views/favorites/state.dart';
import 'FavoritePanel.dart';

/// State for the favorite place component.
/// It is an expansion panel, composed as follows:
///   * header contains name and address of the place, and its current
///     popularity (if it exists)
///   * body contains a graph showing the place popularity (if it exists)
class FavoritePanelState extends State<FavoritePanel> {
  final Favorite place;
  final Function dialogCallback;
  final Function expansionCallback;
  final Function headerBuilder;
  final FavoritesState state;
  Future<PopularTimes> future;
  FavoritePanelState(this.place, this.dialogCallback, this.expansionCallback, this.headerBuilder, this.state);

  /// This component is built from popular times data.
  /// By putting the data call here, we avoid to call the parser each time this
  /// component needs to be rebuilt.
  @override
  void initState () {
    future = AppModel.parser.getPopularTimes(place);
    super.initState();
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final CrowdRate selectedDatum = model.selectedDatum[0].datum as CrowdRate;
    if (selectedDatum.rate != 0) {
      String message = FlutterI18n.translate(context, "favorites_usual_popularity_text1") +
          " ${selectedDatum.rate}% " + FlutterI18n.translate(context, "favorites_usual_popularity_text2") +
          " ${selectedDatum.hour} " + FlutterI18n.translate(context, "favorites_usual_popularity_text3") +
          " ${int.parse(selectedDatum.hour.substring(0, selectedDatum.hour.length-1))+1}h.";

      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build (BuildContext context) {
    // fetching data when pulling-to-refresh
    if (FavoritesState.isRefreshing) {
      future = AppModel.parser.getPopularTimes(place);
    }

    // is called again when the parser returns data
    return FutureBuilder (
      future: future,
      builder: (context, snapshot) {
        // telling state that this component is loaded
        if (snapshot.connectionState == ConnectionState.done)
          state.panelIsLoaded();

        // if the parser hasn't returned data yet, displays a loader
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

        // data has been loaded
        PopularTimes times = snapshot.data;

        // if this place has no popular times, displays a message
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
            SimpleBarChart.fromPopularTimes ( weekstats.times, _onSelectionChanged ),
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

          // if the weekday has no popularity data, tells the user the place is
          // not operating on this day
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