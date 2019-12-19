import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/customTemplates/colours.dart';
// import 'ticker.dart';

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
        TimerText(),

        // Timer buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            CircleButton(buttonText: "START"),
            CircleButton(buttonText: 'END'),
          ],
        )
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
        Text(
          "00:00",
          style: Theme.of(context).textTheme.title,
        ),        
      ],
    );
  }
}

class CircleButton extends StatelessWidget {
  CircleButton({Key key, this.buttonText}) : super(key: key);

  final String buttonText;

  @override

  Widget build(BuildContext context) {
    return Container (
      width: 90.0,
      height: 90.0,
      padding: EdgeInsets.all(6.0),

      decoration: new BoxDecoration(
        border: Border.all(color: purple[500], width: 2.0),
        shape: BoxShape.circle,
      ),

      child: FlatButton(
        onPressed: () { /*...*/ },

        color: purple[500],
        textColor: Colors.white,
        padding: EdgeInsets.all(0),
        shape: new CircleBorder(),

        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.body1,
        ),
      ),      
    );
  }
}