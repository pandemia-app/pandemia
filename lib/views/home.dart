import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    title: new Text('Fonctionnement'),
                    contentPadding: padding,
                    subtitle: Text("Pandemia propose plusieurs fonctionnalités vous permettant de gérer vos déplacements en période de pandémie."+
                        "Elle calcule vos indicateurs d'exposition et de diffusion (voir ce lien pour le détail des calculs), et vous" +
                        "permet également de consulter l'affluence de vos lieux favoris, afin de savoir à quel moment s'y rendre est" +
                        "le moins risqué."),
                ),
                new ListTile(
                  leading: new Icon(Icons.data_usage),
                  contentPadding: padding,
                  title: new Text('Données personnelles'),
                  subtitle: Text("Pandemia est une application fonctionnant en autonomie ; elle ne transmet pas vos informations à un quelconque parti." +
                        "Si vous activez la géolocalisation de votre smartphone, nous utilisons les positions remontées par celui-ci pour" +
                        "améliorer les résultats de nos calculs ; ces positions sont stockées sur votre smartphone, et n'en sortent pas."),
                ),
                new ListTile(
                  leading: new Icon(Icons.warning),
                  contentPadding: padding,
                  title: new Text('Avertissement'),
                  subtitle: Text("Les informations calculées par Pandemia ne remplacent en aucun cas un test de dépistage, mais elles peuvent " +
          "contribuer à identifier la nécessité de se faire dépister auprès de professionnels de santé."),
                ),
                new ListTile(
                  leading: new Icon(Icons.code),
                  contentPadding: padding,
                  title: new Text('Sources'),
                  subtitle: Text("Le code source de Pandemia est accessible à l'adresse suivante : https://github.com/pandemia-app/pandemia"),
                ),
              ],
            ),
          );
        }
    );
  }
}