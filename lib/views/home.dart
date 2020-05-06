import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/home/expositionProgressionCard.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeView extends StatelessWidget {
  HomeView();
  final IndicatorsComputer computer = new IndicatorsComputer();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh(context) async{
    await computer.forceReportRecomputing(context);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // launching analysis
    computer.generateRandomReport(context);

    return SafeArea (
      child: Scaffold(
        backgroundColor: CustomPalette.background[700],
        body: SmartRefresher(
            enablePullDown: true,
            header: ClassicHeader(
                idleText: FlutterI18n.translate(context, "favorites_pullrefresh_idle"),
                releaseText: FlutterI18n.translate(context, "favorites_pullrefresh_release"),
                refreshingText: FlutterI18n.translate(context, "favorites_pullrefresh_refreshing"),
                completeText: FlutterI18n.translate(context, "favorites_pullrefresh_complete")),
            controller: _refreshController,
            onRefresh: () => _onRefresh(context),
            onLoading: _onLoading,
            child: ListView(
                children: <Widget>[
                  MyExpositionCard('exposition for today'),
                  ExpositionProgressionCard('exposition progression'),
                  VisitedPlacesCard("places i've visited today")
                ]
            ),
        )
      )
    );
  }
}