import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/lineChart.dart';

class ExpositionProgressionCard extends CustomCard {
  ExpositionProgressionCard(String title) : super('');

  @override
  Widget build(BuildContext context) {
    return
      new Container (
        height: 400,
        color: cardColor,
        child: Stack (
          children: <Widget>[
            Container (
                child: SimpleLineChart.withSampleData(),
                margin: EdgeInsets.fromLTRB(10, 50, 10, 10)
            ),

            Container(
              child: new Text(
                "Exposition progression",
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
                  "From 30/03/2020",
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
      );
  }
}