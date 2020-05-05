import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/gaugeChart.dart';
import 'package:intl/intl.dart';

class MyExpositionCard extends StatelessWidget {
  MyExpositionCard(String title);
  final IndicatorsComputer computer = new IndicatorsComputer();

  Widget build(BuildContext context) {
    return FutureBuilder<int> (
      future: computer.generateReport(),
        builder: (context, AsyncSnapshot<int> snapshot) {

          if (!snapshot.hasData) {
            return Container (
              color: CustomPalette.background[600],
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: 180,
              height: 212,
              child: Center(
                child: CircularProgressIndicator(),
              )
            );
          }

          return Container (
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Stack (
              children: <Widget>[
                Container(
                  color: CustomPalette.background[600],

                  child: Stack (
                    children: <Widget>[
                      Container (
                        child: GaugeChart.fromRate(snapshot.data),
                        margin: EdgeInsets.all(10),
                        // transform: Matrix4.translationValues(0, 40, 0),
                      ),

                      Container(
                        child: new Text(
                          FlutterI18n.translate(context, "home_myexposition_title"),
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
                            new DateFormat("dd/MM/yyyy").format(new DateTime.now()),
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
    );
  }
}