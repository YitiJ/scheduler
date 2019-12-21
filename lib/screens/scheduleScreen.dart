import 'package:flutter/material.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/customTemplates/themes.dart';
import 'package:scheduler/customTemplates/colours.dart';

import 'package:intl/intl.dart';

import 'timelineScreen.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({Key key, this.date}) : super (key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _headerNav(),
          _headerDate(date),

          Expanded(
            child: TimelineScreen(),
          ),
        ],
      ),
    );
  }
}

Widget _headerNav() {
  return Stack(
    children: <Widget>[
      FlatButton(
        child: Row(
          children: [
            Icon(
              Icons.arrow_left,
              color: Colors.white,
            ),
            Container(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                'BACK',
                style: mainTheme.textTheme.body1,
              ),
            ),
          ],
        ),
      ),

      SegmentedControl(),
    ],
  );
}

class SegmentedControl extends StatelessWidget {
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
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white)))
        ),

        Container(
          padding: EdgeInsets.only(top: 5.0),
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              'To-do List',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _headerDate(DateTime date) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20.0),
    child: Text(
      DateFormat.yMMMMd().format(date),
      style: mainTheme.textTheme.body1,
    ),
  );
}