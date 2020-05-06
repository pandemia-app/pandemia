import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/home/expositionProgressionCard.dart';
import 'package:pandemia/components/home/myExpositionCard.dart';
import 'package:pandemia/components/home/visitedPlacesCard.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class HomeView extends StatelessWidget {
  HomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea (
      child: Scaffold(
        backgroundColor: CustomPalette.background[700],
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info_outline),
          onPressed: () {
            _settingModalBottomSheet(context);
          },
        ),
        body: ListView(
            children: <Widget>[
              MyExpositionCard('exposition for today'),
              ExpositionProgressionCard('exposition progression'),
              VisitedPlacesCard("places i've visited today")
            ]
        ),
      )
    );
  }

  void _settingModalBottomSheet (context){
    var padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.info_outline),
                    title: new Text(
                      FlutterI18n.translate(context, "home_info_operation_title"),
                    ),
                    contentPadding: padding,
                    subtitle: Text(
                      FlutterI18n.translate(context, "home_info_operation_text1") + '\n' +
                          FlutterI18n.translate(context, "home_info_operation_text2"),
                    ),
                ),
                new ListTile(
                  leading: new Icon(Icons.data_usage),
                  contentPadding: padding,
                  title: new Text(
                      FlutterI18n.translate(context, "home_info_data_title")
                  ),
                  subtitle: Text(
                    FlutterI18n.translate(context, "home_info_data_text1") + '\n' +
                        FlutterI18n.translate(context, "home_info_data_text2"),
                  ),
                ),
                new ListTile(
                  leading: new Icon(Icons.warning),
                  contentPadding: padding,
                  title: new Text(
                      FlutterI18n.translate(context, "home_info_disclaimer_title")
                  ),
                  subtitle: Text(
                      FlutterI18n.translate(context, "home_info_disclaimer_text")
                  ),
                ),
                new ListTile(
                  leading: new Icon(Icons.code),
                  contentPadding: padding,
                  title: new Text(
                      FlutterI18n.translate(context, "home_info_source_title")
                  ),
                  subtitle: Text.rich(
                    TextSpan(
                      text: FlutterI18n.translate(context, "home_info_source_text") + " ",
                      children: <TextSpan>[
                      TextSpan(
                        text: 'https://github.com/pandemia-app/pandemia',
                        style: TextStyle(
                        decoration: TextDecoration.underline,
                      )),
                      ],
                    )
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}