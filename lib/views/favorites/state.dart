import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/views/favorites/view.dart';

class FavoritesState extends State<FavoritesView> {
  AppDatabase db = new AppDatabase();
  List<Favorite> _data = new List();

  void _addSamplePlaces () {
    setState(() {
      for (var f in _data)
        f.isExpanded = false;
      _data.add
        (Favorite (id: DateTime.now().millisecondsSinceEpoch,
          name: "MONOPRIX Dunkerque",
          address: "9 Place de la République, 59140 Dunkerque"));
      _data.add
        (Favorite (id: DateTime.now().millisecondsSinceEpoch,
          name: "3 Brasseurs Dunkerque",
          address: "Rue des Fusiliers Marins, 59140 Dunkerque"));
      _data.add
        (Favorite (id: DateTime.now().millisecondsSinceEpoch,
            name: "Cora Dunkerque",
            address: "BP, 50039 Rue Jacquard, 59411 Coudekerque-Branche"));
    });
  }


  void _showDialog(Favorite item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remove place"),
          content: new Text("Do you want to remove ${item.name} from your favorite places?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Remove"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _data.removeWhere((i) => i == item);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomPalette.background[700],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addSamplePlaces(),
        tooltip: "Add sample places",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: _buildPanel(),
            padding: EdgeInsets.all(20),
          ),
        ),
      )
    );
  }

  Widget _buildPanel() {
    return
      Container(
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
                  return GestureDetector(
                    onLongPress: () => _showDialog(item),
                    child: Container (
                      margin: EdgeInsets.all(0),
                      child: ListTile(
                        title: Text(item.name, style: TextStyle(color: CustomPalette.text[200])),
                        subtitle: Text(item.address,
                          style: TextStyle(color: CustomPalette.text[500]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: isExpanded ? 3 : 1,
                        ),
                      ),
                    )
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