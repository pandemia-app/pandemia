import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class GaugeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final double pi = 3.14;

  GaugeChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory GaugeChart.withSampleData() {
    return new GaugeChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Center(
          child: Text("30%", style: TextStyle(fontSize: 42, color: CustomPalette.text[400]),),
        ),

        charts.PieChart(
            seriesList,
            animate: animate,
            defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 30, startAngle: 4/5 * pi, arcLength: 7/5*pi)),

        Center (
          child: Container (
            width: 200,
            transform: Matrix4.translationValues(25, 50, 0),
            child: Text("I might have been exposed today",
                style: TextStyle(fontSize: 20, color: CustomPalette.text[400])),
          ),
        )
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData() {
    final data = [
      new GaugeSegment('Contamination rate', 30),
      new GaugeSegment('Space', 70),
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