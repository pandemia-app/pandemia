import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/lineChart.dart';

class ExpositionProgressionCard extends CustomCard {
  ExpositionProgressionCard(String title) : super('');

  @override
  Widget build(BuildContext context) {
    return
      new Container (
        height: 400,
        color: cardColor,
        child: Stack (
          children: <Widget>[
            Container (
                child: buildGraph(),
                margin: EdgeInsets.fromLTRB(15, 60, 0, 15),
            ),

            Container(
              child: new Text(
                FlutterI18n.translate(context, "home_expositionprogression_title"),
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
                  FlutterI18n.translate(context, "home_expositionprogression_since") +
                  " 30/03/2020",
                  style: TextStyle(
                      color: CustomPalette.text[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
            ),
          ],
        ),
      );
  }

  Widget buildGraph () {
    return FutureBuilder<List<TimeExposition>>(
        future: TimeSeriesChart.reportsData(),
        builder: (context, AsyncSnapshot<List<TimeExposition>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var data = snapshot.data;
          if (data.length == 0) {
            return Container(
              child: Center (
                child: Text(
                  "No progression to display yet",
                  style: TextStyle(
                      color: CustomPalette.text[100],
                      fontSize: 20,
                      fontWeight: FontWeight.w300
                  ),
                ),
              ),
            );
          } else
            return TimeSeriesChart.fromReports(data);
        }
    );
  }
}