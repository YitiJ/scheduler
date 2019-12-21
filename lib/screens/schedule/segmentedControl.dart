import 'package:flutter/material.dart';
import 'package:scheduler/bloc/segmentedControl/segmentedControl_bloc.dart';

class SegmentedControl extends StatefulWidget {
  SegmentedControl({Key key, this.curInd, this.bloc}) : super (key: key);

  final Option curInd;
  final SegmentedControlBloc bloc;

  @override
  SegmentedControlState createState() => SegmentedControlState();
}


class SegmentedControlState extends State<SegmentedControl> {
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
              style: TextStyle(color: widget.curInd == Option.timeline ? Colors.white : Colors.white70),
            ),
            onPressed: () => {widget.bloc.changePage(widget.curInd)},
          ),

          decoration: widget.curInd == Option.timeline ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))) : null,
        ),

        Container(
          padding: EdgeInsets.only(top: 5.0),

          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              'To-do List',
              style: TextStyle(color: widget.curInd == Option.todo ? Colors.white : Colors.white54),
            ),
            onPressed: () => {widget.bloc.changePage(widget.curInd)},
          ),

          decoration: widget.curInd == Option.todo ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))) : null,
        ),
      ],
    );
  }
}