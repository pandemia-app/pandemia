import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/views/favorites/view.dart';

List<Favorite> generateItems() {
  return [
    Favorite (name: "MONOPRIX Dunkerque", address: "9 Place de la République, 59140 Dunkerque"),
    Favorite (name: "3 Brasseurs Dunkerque", address: "Rue des Fusiliers Marins, 59140 Dunkerque"),
    Favorite (name: "Cora Dunkerque", address: "BP, 50039 Rue Jacquard, 59411 Coudekerque-Branche")
  ];
}

class FavoritesState extends State<FavoritesView> {
  List<Favorite> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
        padding: EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildPanel() {
    return
      Container(
        color: CustomPalette.background[700],
        margin: EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(
              cardColor: CustomPalette.background[500],
          ),
          child:ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                for (var i=0, len=_data.length; i<len; i++) {
                  _data[i].isExpanded =
                  i == index ? !isExpanded : false;
                }
              });
            },
            children: _data.map<ExpansionPanel>((Favorite item) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container (
                    margin: EdgeInsets.all(0),
                    child: ListTile(
                      title: Text(item.name, style: TextStyle(color: CustomPalette.text[200])),
                      subtitle: Text(item.address, style: TextStyle(color: CustomPalette.text[500])),
                    ),
                  );
                },
                body: Card(
                  margin: EdgeInsets.all(0),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.zero,
                  ) ,
                  borderOnForeground: true,
                  color: CustomPalette.background[600],
                  child: Container (
                    height: 200,
                    child: SimpleBarChart.withSampleData(),
                  ),
                ),
                isExpanded: item.isExpanded
              );
            }).toList(),
          )
        )
      );
  }
}