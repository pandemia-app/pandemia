import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/utils/information/GeoSwitch.dart';
import 'package:url_launcher/url_launcher.dart';

/// Displays a text sheet displaying information about the application.
class InformationSheet {
  BuildContext _context;
  EdgeInsets _padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  GeoSwitch _switch = new GeoSwitch();
  InformationSheet(this._context);

  void show () {
    showModalBottomSheet(
        context: _context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.info_outline),
                  title: new Text(
                    FlutterI18n.translate(_context, "home_info_operation_title"),
                  ),
                  contentPadding: _padding,
                  subtitle: Text(
                    FlutterI18n.translate(_context, "home_info_operation_text1") + '\n' +
                        FlutterI18n.translate(_context, "home_info_operation_text2"),
                  ),
                ),
                new ListTile(
                  leading: new Icon(Icons.data_usage),
                  contentPadding: _padding,
                  title: new Text(
                      FlutterI18n.translate(_context, "home_info_data_title")
                  ),
                  subtitle: Text(
                      FlutterI18n.translate(_context, "home_info_data_text1")
                  ),
                ),
                new ListTile(
                  onTap: () => _switch.toggle(),
                  leading: new Icon(Icons.location_on),
                  contentPadding: _padding,
                  title: new Text(
                      FlutterI18n.translate(_context, "home_info_location_title")
                  ),
                  subtitle: Text(
                      FlutterI18n.translate(_context, "home_info_location_text")
                  ),
                  trailing: _switch,
                ),
                new ListTile(
                  leading: new Icon(Icons.warning),
                  contentPadding: _padding,
                  title: new Text(
                      FlutterI18n.translate(_context, "home_info_disclaimer_title")
                  ),
                  subtitle: Text(
                      FlutterI18n.translate(_context, "home_info_disclaimer_text")
                  ),
                ),
                new ListTile(
                  onTap: _openRepositoryURL,
                  leading: new Icon(Icons.code),
                  contentPadding: _padding,
                  title: new Text(
                      FlutterI18n.translate(_context, "home_info_source_title")
                  ),
                  subtitle: Text.rich(
                      TextSpan(
                        text: FlutterI18n.translate(_context, "home_info_source_text") + " ",
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

  /// Redirects the user to the application's GitHub repository on the web.
  _openRepositoryURL () async {
    const url = 'https://github.com/pandemia-app/pandemia';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}