import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

/// Bar chart used to display popularity statistics.
class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final Function onTouchCallback;

  SimpleBarChart(this.seriesList, this.onTouchCallback, {this.animate});

  factory SimpleBarChart.fromPopularTimes(List<List<int>> times, Function onTouchCallback) {
    return new SimpleBarChart(
      _createDataFromPopularTimes(times),
      onTouchCallback,
      animate: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.InitialSelection(selectedDataConfig: [
          new charts.SeriesDatumConfig<String>("Crowds", "${DateTime.now().hour}h")
        ])
      ],
      selectionModels: [
        new charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: this.onTouchCallback
        )
      ],
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
                  new charts.TickSpec('1h'),
                  new charts.TickSpec('3h'),
                  new charts.TickSpec('5h'),
                  new charts.TickSpec('7h'),
                  new charts.TickSpec('9h'),
                  new charts.TickSpec('11h'),
                  new charts.TickSpec('13h'),
                  new charts.TickSpec('15h'),
                  new charts.TickSpec('17h'),
                  new charts.TickSpec('19h'),
                  new charts.TickSpec('21h'),
                  new charts.TickSpec('23h'),
                ]
            )),
    );
  }

  /// Converts popularity statistics into graph-compatible data.
  static List<charts.Series<CrowdRate, String>> _createDataFromPopularTimes(List<List<int>> times) {
    final List<CrowdRate> data = [];

    for (var time in times) {
      data.add(new CrowdRate("${time.first}h", time.last));
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