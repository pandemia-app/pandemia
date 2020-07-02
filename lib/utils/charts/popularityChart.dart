import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

/// Circular chart displaying the current popularity of a place.
class PopularityChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final int rate;
  final double pi = 3.14;

  PopularityChart(this.rate, this.seriesList, {this.animate});

  factory PopularityChart.fromRate(int rate) {
    return new PopularityChart(
      rate,
      _createData(rate),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container (
      child: Column (
          children: <Widget>[
            Container (
              transform: Matrix4.translationValues(0, 10, 0),
              child: Text("$rate%", style: TextStyle(fontSize: 12, color: CustomPalette.text[400],)),
            ),
            Container (
              width: 40,
              height: 40,
              transform: Matrix4.translationValues(-10, -5, 0),
              child: charts.PieChart(
                  seriesList,
                  animate: animate,
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 2, startAngle: pi, arcLength: 2*pi)),
            )
          ]),
    );
  }

  static List<charts.Series<GaugeSegment, String>> _createData(int rate) {
    var value = rate > 100 ? 100 : rate;
    final data = [
      new GaugeSegment('Popularity', value),
      new GaugeSegment('Space', 100 - value),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
      )
    ];
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}