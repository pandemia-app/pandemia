import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'package:pandemia/data/database/models/DailyReport.dart';
import 'package:pandemia/data/state/AppModel.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/lineChart.dart';
import 'package:provider/provider.dart';

/// Card displaying the user exposition progression over days.
/// It gets exposition data stored in the app model, and displays it as a graph.
class ExpositionProgressionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, model, child) {
        List<DailyReport> reports = model.reports;

        return new Container (
          height: 400,
          color: CustomPalette.background[600],
          child: Stack (
            children: <Widget>[
              Container (
                child: buildGraph(reports),
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
                  child: buildGraphSubtitle(reports, context),
                  padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildGraphSubtitle (List<DailyReport> reports, BuildContext context) {
    if (reports.length == 0) {
      return new Container();
    }

    DailyReport report = reports.first;
    DateTime oldest = DateTime.fromMillisecondsSinceEpoch(
      report.timestamp,
    );

    return new Text(
      FlutterI18n.translate(context, "home_expositionprogression_since") + " " +
          new DateFormat("dd/MM/yyyy").format(oldest),
      style: TextStyle(
          color: CustomPalette.text[600],
          fontSize: 18,
          fontWeight: FontWeight.w300
      ),
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