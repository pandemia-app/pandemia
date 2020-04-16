import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/gaugeChart.dart';

class MyExpositionCard extends StatelessWidget {
  MyExpositionCard(String title);

  String getFormattedDate () {
    return "16/04/2020";
  }

  Widget build(BuildContext context) {
    return Container (
      child: Stack (
        children: <Widget>[
          Container(
            color: CustomPalette.background[600],

            child: Stack (
              children: <Widget>[
                Container (
                  child: GaugeChart.withSampleData(),
                  margin: EdgeInsets.all(10),
                  // transform: Matrix4.translationValues(0, 40, 0),
                ),

                Container(
                  child: new Text(
                    "Virus exposition",
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
                      getFormattedDate(),
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
          )
        ],
      ),
    );
  }
}