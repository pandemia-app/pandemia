import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../CustomPalette.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis:
        new charts.NumericAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: true,
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.text[600])
              ),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.background[500])
              )
          ),

          tickProviderSpec:
            new charts.StaticOrdinalTickProviderSpec(
                <charts.TickSpec<String>>[
                  new charts.TickSpec('7'),
                  new charts.TickSpec('9'),
                  new charts.TickSpec('11'),
                  new charts.TickSpec('13'),
                  new charts.TickSpec('15'),
                  new charts.TickSpec('17'),
                  new charts.TickSpec('19'),
                  new charts.TickSpec('21'),
                ]
            )),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CrowdRate, String>> _createSampleData() {
    final markers = [];
    final data = new List<CrowdRate>();
    final rates = [0, 0, 0, 0, 0, 0, 0, 0, 20, 25, 30, 40, 35, 38, 42, 45, 42, 57, 62, 0, 0, 0, 0, 0, 0];

    // first hour
    var index = 0;
    while (rates[index] == 0)
      index++;
    markers.add(index-1);

    // last hour
    // start iteration from the end (some places close at noon)
    index = rates.length-1;
    while (rates[index] == 0)
      index--;
    markers.add(index+2);

    for (var i=markers[0]; i<markers[1]; i++) {
      data.add(new CrowdRate(i.toString(), rates[i]));
    }

    return [
      new charts.Series<CrowdRate, String>(
        id: 'Crowds',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CrowdRate cr, _) => cr.hour,
        measureFn: (CrowdRate cr, _) => cr.rate,
        data: data
      )
    ];
  }
}

class CrowdRate {
  final String hour;
  final int rate;

  CrowdRate (this.hour, this.rate);
}