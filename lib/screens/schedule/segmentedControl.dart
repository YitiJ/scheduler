import 'package:flutter/material.dart';
import 'package:scheduler/bloc/segmentedControl/segmentedControl_bloc.dart';
import 'package:scheduler/customTemplates/themes.dart';

class SegmentedControl extends StatelessWidget {
  SegmentedControl({Key key, this.curInd, this.bloc}) : super (key: key);
  
  final Option curInd;
  final SegmentedControlBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
    
      children: <Widget>[
        _segmentElement('Timeline', Option.timeline),
        _segmentElement('To-do List', Option.todo),
      ],
    );
  }

  Widget _segmentElement(String text, Option targetInd) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),

      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          text,
          style: mainTheme.textTheme.body1.copyWith(
            color: curInd == targetInd ? Colors.white : Colors.white70,
          ),
        ),
        onPressed: () => bloc.changePage(targetInd),
      ),

      decoration: curInd == targetInd ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))) : null,
    );
  }
}