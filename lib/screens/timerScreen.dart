import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/bloc/timer/timer.dart';
import 'package:scheduler/screens/schedule/scheduleScreen.dart';

import 'package:scheduler/data/dbManager.dart';

import 'package:scheduler/customTemplates/export.dart';

class TimerScreen extends StatelessWidget {
  TimerScreen({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: header(context),
          ),
          Content(),
        ],
      ),
    );
  }

  Widget header(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              'TODAY',
              style: mainTheme.textTheme.body1,
            ),
          ),
          Icon(
            Icons.arrow_right,
            color: Colors.white,
          ),
        ],
      ),
      onPressed: () async {
        final dbManager = DbManager.instance;

        final todo = await dbManager.getAllTask();

        Navigator.push(context, CupertinoPageRoute(
          builder: (_) => ScheduleScreen(date: DateTime.now(), todo: todo)));
      },
    );
  }
}

class Content extends StatelessWidget {
  Content({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        
      children: [
        TimerText(),
      ],
    );
  }
}

class TimerText extends StatelessWidget {
  TimerText({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 25.0),
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              final String minutesStr = ((state.duration / 60) % 60)
                  .floor()
                  .toString()
                  .padLeft(2, '0');
              final String secondsStr =
                  (state.duration % 60).floor().toString().padLeft(2, '0');
              return Text(
                '$minutesStr:$secondsStr',
                style: Theme.of(context).textTheme.title,
              );
            },
          ),
        ), 

        BlocBuilder<TimerBloc, TimerState>(
            condition: (previousState, state) =>
                state.runtimeType != previousState.runtimeType,
            builder: (context, state) => _Actions(),
          ),      
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    TimerBloc timerBloc,
  }) {
    final TimerState currentState = timerBloc.state;
    if (currentState is Ready) {
      return [
        ThemedButton(
          text: 'START',
          size: 90.0,
          callback: () =>
              timerBloc.add(Start(duration: currentState.duration)),
        ),
        ThemedButton(
          text: 'END',
          size: 90.0,
          callback: null,
        ),
      ];
    }
    if (currentState is Running) {
      return [
        ThemedButton(
          text: 'PAUSE',
          size: 90.0,
          callback: () =>
              timerBloc.add(Pause()),
        ),
        ThemedButton(
          text: 'END',
          size: 90.0,
          callback: () =>
              timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Paused) {
      return [
        ThemedButton(
          text: 'START',
          size: 90.0,
          callback: () =>
              timerBloc.add(Resume()),
        ),
        ThemedButton(
          text: 'END',
          size:90.0,
          callback: () =>
              timerBloc.add(Reset()),
        ),
      ];
    }
    return [];
  }
}