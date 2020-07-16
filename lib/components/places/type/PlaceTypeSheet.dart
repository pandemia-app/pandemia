import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:pandemia/components/places/type/placeType.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class PlaceTypeSheet {
  final Function onTypeUpdated;
  final BuildContext context;
  PlaceTypeSheet({this.onTypeUpdated, this.context});

  void updateSelectedType (String key) {
    onTypeUpdated(key);
    Navigator.pop(context);
  }

  void show (String selectedType) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return DraggableScrollableSheet(
            initialChildSize: 1,
            minChildSize: 0.99,
            builder: (BuildContext localContext, ScrollController scrollController) {
              List<Widget> typesItems = [
                ListTile(
                  title: Center(
                    child: Column (
                      children: <Widget>[
                        Icon(Icons.maximize, color: CustomPalette.text[700]),
                        Container (
                          child: Text(FlutterI18n.translate(context, "places_typepicker_title"), style: TextStyle(
                              color: CustomPalette.text[300])),
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.only(bottom: 10),
                        ),
                        Divider (color: CustomPalette.text[300], thickness: 0.5,)
                      ],
                    ),
                  ),
                )];

              for (PlaceType t in PlaceType.getSortedTypes(context)) {
                typesItems.add(
                    ListTile(
                      onTap: () => updateSelectedType(t.key),
                      dense: true,
                      enabled: true,
                      title: Text(t.translation, style: TextStyle(color: CustomPalette.text[300])),
                      leading: Radio(
                          groupValue: selectedType,
                          value: t.key,
                          onChanged: (key) => updateSelectedType(key)
                      ),
                    )
                );
              }

              return Container(
                  color: CustomPalette.background[400],
                  child: ListView(
                    controller: scrollController,
                    children: typesItems,
                  )
              );
            },
          );
        }
    );
  }
}