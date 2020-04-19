import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesChart.withSampleData() {
    return new TimeSeriesChart(
      _generateRandomData(),
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),

      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 10),
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.text[600])
              ),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.background[500])
              )
          )
      ),

      domainAxis: new charts.DateTimeAxisSpec(
          tickProviderSpec: charts.DayTickProviderSpec(increments: [3]),
          renderSpec: new charts.GridlineRendererSpec(
            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.text[600])
              ),
              lineStyle: new charts.LineStyleSpec(
                  color: charts.ColorUtil.fromDartColor(CustomPalette.background[500])
              )
          )
      ),
    );
  }

  /// generates random data from time t to today's date
  static List<charts.Series<TimeExposition, DateTime>> _generateRandomData() {
    var tDate = DateTime.parse("2020-03-30");
    var days = new DateTime.now().difference(tDate).inDays;
    var random = new Random.secure();
    var data = new List<TimeExposition>();
    
    for (var i=0; i<days; i++) {
      data.add(
          new TimeExposition(
              tDate.add(new Duration(days: i)),
              random.nextInt(100)));
    }

    return [
      new charts.Series<TimeExposition, DateTime>(
        id: 'Progression',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeExposition exposition, _) => exposition.time,
        measureFn: (TimeExposition exposition, _) => exposition.value,
        data: data
      )
    ];
  }
}

/// Sample time series data type.
class TimeExposition {
  final DateTime time;
  final int value;

  TimeExposition(this.time, this.value);
}