import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class HomeView extends StatelessWidget {
  HomeView();

  @override
  Widget build(BuildContext context) {
    return
      CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                crossAxisCount: 1,
                children: <Widget>[
                  MyExpositionCard('exposition for today'),
                  CustomCard('progression of the exposition'),
                  VisitedPlacesCard("places i've visited today")
                ],
              ),
          ),
        ],
      );
  }
}