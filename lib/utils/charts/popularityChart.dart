import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

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
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container (
      width: 30,
      height: 30,
      child: Stack (
        children: <Widget>[
          Container (
            width: 30,
            height: 30,
            transform: Matrix4.translationValues(7, 0, 0),
            child: Text("$rate%", style: TextStyle(fontSize: 14, color: CustomPalette.text[400])),
          ),

          Container (
            width: 30,
            height: 40,
            transform: Matrix4.translationValues(-10, 0, 0),
            child: charts.PieChart(
                seriesList,
                animate: animate,
                defaultRenderer: new charts.ArcRendererConfig(
                    arcWidth: 2, startAngle: pi, arcLength: 2*pi)),
          ),
        ],
      ),
    );
  }

  static List<charts.Series<GaugeSegment, String>> _createData(int rate) {
    final data = [
      new GaugeSegment('Popularity', rate),
      new GaugeSegment('Space', 100 - rate),
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