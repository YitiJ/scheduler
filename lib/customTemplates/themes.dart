import 'package:flutter/material.dart';
import 'colours.dart';

final ThemeData mainTheme = ThemeData(
  primarySwatch: purple,

  textTheme: TextTheme(
    title: TextStyle(
      color: Colors.white,
      fontSize: 64.0,
      letterSpacing: 3,
    ),
    subtitle: TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      letterSpacing: 2.0,
      ),
    body1: TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      letterSpacing: 1.0,
      ),
    body2: TextStyle(
      fontSize: 12.0,
      color: purple,
      letterSpacing: 1.0,
      ),
    button: TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      letterSpacing: 1.0,
      ),
    ),
);

InputDecoration textFieldStyle(String text, String error) {
  return InputDecoration(
    hintText: text,
    labelText: text,
    errorText: error,
    helperStyle: mainTheme.textTheme.body2,
    hintStyle: mainTheme.textTheme.body2,
    labelStyle: mainTheme.textTheme.body2,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: purple,
      )
    )
  );
}

InputDecoration searchFieldStyle(String text) {
  return InputDecoration(

    hintText: text,
    labelText: text,
    helperStyle: mainTheme.textTheme.body2,
    hintStyle: mainTheme.textTheme.body2,
    labelStyle: mainTheme.textTheme.body2,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: purple,
      )
    ),
    prefixIcon: Icon(Icons.search, color: purple,),
  );
}