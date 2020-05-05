import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/lineChart.dart';
import 'package:provider/provider.dart';

class ExpositionProgressionCard extends CustomCard {
  ExpositionProgressionCard(String title) : super('');

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        return new Container (
          height: 400,
          color: cardColor,
          child: Stack (
            children: <Widget>[
              Container (
                child: buildGraph(model.reports),
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
      },
    );
  }

  Widget buildGraph (List<DailyReport> reports) {
    print('building graph from $reports');
    if (reports.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return TimeSeriesChart.fromReports(reports);
  }
}