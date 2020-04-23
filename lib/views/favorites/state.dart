import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/views/favorites/view.dart';

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Place no $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class FavoritesState extends State<FavoritesView> {
  List<Item> _data = generateItems(15);

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
              cardColor: CustomPalette.background[400],
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
            children: _data.map<ExpansionPanel>((Item item) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container (
                    margin: EdgeInsets.all(0),
                    child: ListTile(
                      title: Text(item.headerValue, style: TextStyle(color: CustomPalette.text[200])),
                      subtitle: Text('Address', style: TextStyle(color: CustomPalette.text[500])),
                    ),
                  );
                },
                body: Card(
                  margin: EdgeInsets.all(0),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.zero,
                  ) ,
                  borderOnForeground: true,
                  color: CustomPalette.background[300],
                  child: ListTile(
                      title: Text(
                          item.expandedValue,
                        style: TextStyle(color: CustomPalette.text[100]),
                      )
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