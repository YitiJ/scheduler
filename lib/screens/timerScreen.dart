import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/bloc/timer/timer.dart';
import 'package:scheduler/bloc/timer/ticker.dart';
import 'package:scheduler/customTemplates/colours.dart';

import 'package:scheduler/customTemplates/customWidgets.dart';

class TimerScreen extends StatelessWidget {
  TimerScreen({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      child: Content(),
    );
  }
}

class Content extends StatelessWidget {
  Content({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        
      children: [
        BlocProvider(
          create: (context) => TimerBloc(ticker: Ticker()),
          child: TimerText(),
        ),
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
        BlocBuilder<TimerBloc, TimerState>(
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
        _ThemedButton(
          text: 'START',
          callback: () =>
              timerBloc.add(Start(duration: currentState.duration)),
        ),
        _ThemedButton(
          text: 'END',
          callback: null,
        ),
      ];
    }
    if (currentState is Running) {
      return [
        _ThemedButton(
          text: 'PAUSE',
          callback: () =>
              timerBloc.add(Pause()),
        ),
        _ThemedButton(
          text: 'END',
          callback: () =>
              timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Paused) {
      return [
        _ThemedButton(
          text: 'START',
          callback: () =>
              timerBloc.add(Resume()),
        ),
        _ThemedButton(
          text: 'END',
          callback: () =>
              timerBloc.add(Reset()),
        ),
      ];
    }
    return [];
  }
}

class _ThemedButton extends StatelessWidget {
  const _ThemedButton({Key key, this.text, this.callback}) : super(key: key);

  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return CircleButton(
      child: Text(text),
      onPressed: callback,
      color: purple[500],
      disabledColor: purple[200],
      padding: EdgeInsets.all(3.0),
    );
  }
}