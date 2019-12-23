import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/layoutTemplate.dart';

import 'package:scheduler/data/models.dart';
import 'package:scheduler/customTemplates/themes.dart';
import 'package:scheduler/bloc/segmentedControl/segmentedControl_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scheduler/screens/schedule/todoScreen.dart';
import 'timelineScreen.dart';
import 'segmentedControl.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key, this.date}) : super (key: key);
  
  static const routeName = '/scheduleHistory';
  DateTime date;

  @override
  ScheduleScreenState createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  SegmentedControlBloc _segmentedControlBloc;

  @override
  void initState() {
    super.initState();
    _segmentedControlBloc = SegmentedControlBloc();
  }

  @override
  void dispose() {
    _segmentedControlBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutTemplate.getPageWidget(
        Container(
          child: Column(
            children: <Widget>[
              _headerNav(_segmentedControlBloc),
              _headerDate(widget.date),
              
              StreamBuilder(
                stream: _segmentedControlBloc.segmentStream,
                builder: (context, snapshot) {
                  switch (snapshot.data) {
                    case Option.timeline:
                      return Expanded(
                        child: TimelineScreen(),
                      );
                    case Option.todo:
                      return TodoScreen();
                    default:
                      return Expanded(
                        child: TimelineScreen(),
                      );
                    }
                  }
                )    
              ]
            )
          ),
          null)
      );
    }
}

Widget _headerNav(SegmentedControlBloc segmentBloc) {
  return Stack(
    children: <Widget>[
      Positioned(
        left: 0,
        child: _BackBtn(),
      ),
      
      StreamBuilder(
        stream: segmentBloc.segmentStream,
        initialData: segmentBloc.defaultOption,
        builder: (BuildContext context, AsyncSnapshot<Option> snapshot) {
          print(snapshot.data);
          return SegmentedControl(curInd: snapshot.data, bloc: segmentBloc);
        }
      ),
    ],
  );
}

class _BackBtn extends StatelessWidget {
  _BackBtn({Key key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
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
      onPressed: () => Navigator.pop(context),
    );
  }
}

Widget _headerDate(DateTime date) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20.0),
    child: Text(
          DateFormat.yMMMMd().format(date),
          style: mainTheme.textTheme.body1,)
    );
}