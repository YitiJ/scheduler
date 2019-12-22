import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/layoutTemplate.dart';
import 'package:scheduler/customTemplates/themes.dart';
import 'package:scheduler/screens/schedule/scheduleScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler',
      theme: mainTheme,
      home: LayoutTemplate(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case ScheduleScreen.routeName:
            return CupertinoPageRoute(
                builder: (_) => ScheduleScreen(), settings: settings);
        }
      }
    );
  }
}