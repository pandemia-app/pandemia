import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesChart.withSampleData() {
    return new TimeSeriesChart(
      _createSampleData(),
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

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeExposition, DateTime>> _createSampleData() {
    final data = [
      new TimeExposition(new DateTime(2020, 3, 30), 5),
      new TimeExposition(new DateTime(2020, 3, 31), 15),
      new TimeExposition(new DateTime(2020, 4, 2), 30),
      new TimeExposition(new DateTime(2020, 4, 5), 42),
      new TimeExposition(new DateTime(2020, 4, 6), 41),
      new TimeExposition(new DateTime(2020, 4, 8), 39),
      new TimeExposition(new DateTime(2020, 4, 10), 37),
      new TimeExposition(new DateTime(2020, 4, 11), 35),
      new TimeExposition(new DateTime(2020, 4, 13), 33),
      new TimeExposition(new DateTime(2020, 4, 15), 31),
      new TimeExposition(new DateTime(2020, 4, 16), 30),
    ];

    return [
      new charts.Series<TimeExposition, DateTime>(
        id: 'Progression',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeExposition exposition, _) => exposition.time,
        measureFn: (TimeExposition exposition, _) => exposition.value,
        data: data,
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