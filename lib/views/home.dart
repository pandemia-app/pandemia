import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/home/expositionProgressionCard.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';

class HomeView extends StatelessWidget {
  HomeView();

  @override
  Widget build(BuildContext context) {
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