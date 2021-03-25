import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/home/expositionProgressionCard.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/geolocation/VisitedPlacesComputer.dart';
import 'package:pandemia/utils/information/InformationSheet.dart';
import 'package:pandemia/data/database/indicatorsComputer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Home view of the application, showing current exposition rate, exposition
/// progression, and today's visited places.
/// It contains a pull-to-refresh controller, which allows the user to
/// regenerate the exposition report for today.
class HomeView extends StatelessWidget {
  HomeView();
  final GlobalKey<VisitedPlacesCardState> _key = GlobalKey();
  final IndicatorsComputer computer = new IndicatorsComputer();
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh(context) async{
    await computer.forceReportRecomputing(context);
    _refreshController.refreshCompleted();
    VisitedPlacesComputer.computeVisitedPlaces();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // launching analysis
    computer.generateReport(context);
    InformationSheet sheet = new InformationSheet(context);

    return SafeArea (
      child: Scaffold(
        backgroundColor: CustomPalette.background[700],
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info_outline),
          onPressed: () {
            sheet.show();
          },
        ),
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
                  MyExpositionCard(),
                  ExpositionProgressionCard(),
                  VisitedPlacesCard(key : _key)
                ]
            ),
        )
      )
    );
  }
}