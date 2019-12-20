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
    button: TextStyle(
      fontSize: 12.0,
      color: Colors.white,
      letterSpacing: 1.0,
      ),
    ),
);