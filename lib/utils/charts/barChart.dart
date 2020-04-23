import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

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
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CrowdRate, String>> _createSampleData() {
    final data = new List<CrowdRate>();
    final rates = [0, 0, 0, 0, 0, 0, 0, 0, 20, 25, 30, 40, 35, 38, 42, 45, 42, 57, 62, 0, 0, 0, 0, 0, 0];
    for (var i=0; i<25; i++) {
      data.add(new CrowdRate(i.toString(), rates[i]));
    }

    return [
      new charts.Series<CrowdRate, String>(
        id: 'Crowds',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (CrowdRate cr, _) => cr.hour,
        measureFn: (CrowdRate cr, _) => cr.rate,
        data: data,
      )
    ];
  }
}

class CrowdRate {
  final String hour;
  final int rate;

  CrowdRate (this.hour, this.rate);
}