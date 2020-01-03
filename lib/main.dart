import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/customTemplates/export.dart';

import 'package:scheduler/bloc/timer/timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler',
      theme: mainTheme,
      home: BlocProvider<TimerBloc>(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: LayoutTemplate(),
      ),
    );
  }
}