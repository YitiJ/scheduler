import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scheduler/customTemplates/colours.dart';
// import 'package:scheduler/themes.dart';

class TimerScreen extends StatelessWidget {
  TimerScreen({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          TimerText(num1: '00', num2: '00'),

          // Timer buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              CircleButton(buttonText: 'START'),
              CircleButton(buttonText: 'END'),
            ],
          )
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  TimerText({Key key, this.num1, this.num2}) : super(key: key);

  final String num1, num2;

  @override

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          num1 + ':' + num2,
          style: TextStyle(
            fontSize: 64.0,
            color: Colors.white,
            letterSpacing: 3,
          ),
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
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ),      
    );
  }
}