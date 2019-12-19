import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/layoutTemplate.dart';
import 'package:scheduler/customTemplates/themes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler',
      theme: mainTheme,
      home: LayoutTemplate(),
    );
  }
}