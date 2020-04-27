import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/utils/CustomPalette.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container (
        margin: EdgeInsets.all(10),
        child: TextField(
            style: TextStyle(color: CustomPalette.text[400]),
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: CustomPalette.text[400]),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: CustomPalette.text[400]),
                  ),
                  labelStyle: TextStyle(color: CustomPalette.text[400]),
                  labelText: 'Search place...',
              )
          )
      ),
    );
  }

}