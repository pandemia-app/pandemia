import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/home/expositionProgressionCard.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';

class HomeView extends StatelessWidget {
  HomeView();
  final IndicatorsComputer computer = new IndicatorsComputer();

  @override
  Widget build(BuildContext context) {
    // launching analysis
    computer.generateRandomReport(context);

    return SafeArea (
      child: ListView(
        children: <Widget>[
          MyExpositionCard('exposition for today'),
          ExpositionProgressionCard('exposition progression'),
          VisitedPlacesCard("places i've visited today")
        ]
      )
    );
  }
}