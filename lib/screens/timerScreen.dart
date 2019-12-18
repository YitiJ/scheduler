import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scheduler/colours.dart';

class TimerScreen extends StatelessWidget {
  TimerScreen({Key key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        
        children: [
          Container(
            // padding: const EdgeInsets.all(10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                CircleButton(buttonText: 'START'),
                CircleButton(buttonText: 'END'),
              ],
            )
          ),
        ],
      ),
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
          style: TextStyle(fontSize: 12.0, letterSpacing: 1),
        ),
      ),      
    );
  }
}