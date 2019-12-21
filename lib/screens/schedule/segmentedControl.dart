import 'package:flutter/material.dart';
import 'package:scheduler/screens/schedule/timelineScreen.dart';
import 'package:scheduler/screens/schedule/todoScreen.dart';

class SegmentedControl extends StatelessWidget {
  SegmentedControl({Key key, @required this.curInd}) : super (key: key);

  final int curInd;

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
    
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5.0),

          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              'Timeline',
              style: TextStyle(color: curInd == 0 ? Colors.white : Colors.white70),
            ),
            onPressed: () => {},
          ),

          decoration: curInd == 0 ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))) : null,
        ),

        Container(
          padding: EdgeInsets.only(top: 5.0),

          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              'To-do List',
              style: TextStyle(color: curInd == 1 ? Colors.white : Colors.white54),
            ),
            onPressed: () => {},
          ),

          decoration: curInd == 1 ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))) : null,
        ),
      ],
    );
  }
}