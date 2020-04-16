import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/components/card.dart';
import 'package:pandemia/components/visitedPlacesCard.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class HomeView extends StatelessWidget {
  HomeView();
  final Color cardColor = CustomPalette.palette[600];

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
                  CustomCard("my exposition for today"),
                  CustomCard('progression of the exposition'),
                  VisitedPlacesCard("places i've visited today")
                ],
              ),
          ),
        ],
      );
  }
}