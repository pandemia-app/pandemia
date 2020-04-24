import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/views/favorites/view.dart';

class FavoritesState extends State<FavoritesView> {
  AppDatabase db = new AppDatabase();
  final List<Favorite> _data = new List();

  void _addSamplePlaces () async {
    var now = DateTime.now().millisecondsSinceEpoch;
    var p1 = Favorite (id: now + 1,
        name: "MONOPRIX Dunkerque",
        address: "9 Place de la République, 59140 Dunkerque");
    var p2 = Favorite (id: now + 2,
        name: "3 Brasseurs Dunkerque",
        address: "Rue des Fusiliers Marins, 59140 Dunkerque");
    var p3 = Favorite (id: now + 3,
        name: "Cora Dunkerque",
        address: "BP, 50039 Rue Jacquard, 59411 Coudekerque-Branche");

    var futures = <Future>[
      db.insertFavoritePlace(p1),
      db.insertFavoritePlace(p2),
      db.insertFavoritePlace(p3)
    ];

    // forcing component refresh
    await Future.wait(futures);
    setState(() {
      _data.add(p1);
      _data.add(p2);
      _data.add(p3);
      for (var f in _data)
        f.isExpanded = false;
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
                db.removeFavoritePlace(item.id)
                .then((_) {
                  setState(() {
                    _data.removeWhere((i) => i == item);
                  });
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
    return FutureBuilder<List<Favorite>>(
        future: db.getFavoritePlaces(),
        builder: (context, AsyncSnapshot<List<Favorite>> snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();

          if (_data.length == 0) {
            _data.clear();
            _data.addAll(snapshot.data);
            print('building ${snapshot.data.length} items');
          }

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