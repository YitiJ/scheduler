import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/customTemplates/colours.dart';
import 'package:scheduler/bloc/bloc.dart';
import 'package:scheduler/bloc/timer/ticker.dart';

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

        // Timer buttons
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        //   children: [
        //     CircleButton(buttonText: "START"),
        //     CircleButton(buttonText: 'END'),
        //   ],
        // )  

        BlocBuilder<TimerBloc, TimerState>(
            condition: (previousState, state) =>
                state.runtimeType != previousState.runtimeType,
            builder: (context, state) => Actions(),
          ),      
      ],
    );
  }
}

class Actions extends StatelessWidget {
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
        CircleButton(
          child: Text('START'),
          onPressed: () =>
              timerBloc.add(Start(duration: currentState.duration)),
        ),
      ];
    }
    if (currentState is Running) {
      return [
        CircleButton(
          child: Text('PAUSE'),
          onPressed: () =>
              timerBloc.add(Pause()),
        ),
        CircleButton(
          child: Text('END'),
          onPressed: () =>
              timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Paused) {
      return [
        CircleButton(
          child: Text('START'),
          onPressed: () =>
              timerBloc.add(Resume()),
        ),
        CircleButton(
          child: Text('END'),
          onPressed: () =>
              timerBloc.add(Reset()),
        ),
      ];
    }
    return [];
  }
}

class CircleButton extends MaterialButton {
  const CircleButton({
    Key key,
    @required VoidCallback onPressed,
    @required Widget child,
  }) : super(
         key: key,
         onPressed: onPressed,
         child: child,
      );


  @override

  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonThemeData buttonTheme = theme.buttonTheme.copyWith(
        padding: EdgeInsets.all(0),
        shape: new CircleBorder(),
    );

    return Container (
      width: 85.0,
      height: 85.0,
      padding: EdgeInsets.all(5.0),

      decoration: new BoxDecoration(
        border: Border.all(color: purple[500], width: 2.0),
        shape: BoxShape.circle,
      ),

      child: RawMaterialButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHighlightChanged: onHighlightChanged,

        /* Some bugs in setting localized button theme --- temporary fix, need to fix later */

        fillColor: purple[500],
        textStyle: theme.textTheme.button,
        focusColor: buttonTheme.getFocusColor(this),
        hoverColor: buttonTheme.getHoverColor(this),
        highlightColor: buttonTheme.getHighlightColor(this),
        splashColor: buttonTheme.getSplashColor(this),
        elevation: buttonTheme.getElevation(this),
        focusElevation: buttonTheme.getFocusElevation(this),
        hoverElevation: buttonTheme.getHoverElevation(this),
        highlightElevation: buttonTheme.getHighlightElevation(this),
        disabledElevation: buttonTheme.getDisabledElevation(this),

        padding: buttonTheme.getPadding(this),
        constraints: buttonTheme.getConstraints(this),
        shape: buttonTheme.getShape(this),
        materialTapTargetSize: buttonTheme.getMaterialTapTargetSize(this),
        animationDuration: buttonTheme.getAnimationDuration(this),
        child: child,  
      ),      
    );
  }
}