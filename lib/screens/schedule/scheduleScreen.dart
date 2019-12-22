import 'package:flutter/material.dart';

import 'package:scheduler/data/models.dart';
import 'package:scheduler/customTemplates/themes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/navBar/navbar_bloc.dart';
import 'package:scheduler/bloc/segmentedControl/segmentedControl_bloc.dart';

import 'package:intl/intl.dart';
import 'package:scheduler/screens/schedule/todoScreen.dart';

import 'timelineScreen.dart';
import 'segmentedControl.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key, this.bloc}) : super (key: key);

  final BottomNavBarBloc bloc;

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
    return Container(
      child: Column(
        children: <Widget>[
          _headerNav(_segmentedControlBloc, widget.bloc),
          _headerDate(widget.bloc),

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
            },
          ),    
        ],
      ),
    );
  }
}

Widget _headerNav(SegmentedControlBloc segmentBloc, BottomNavBarBloc bottomnNavBloc) {
  return Stack(
    children: <Widget>[
      Positioned(
        left: 0,
        child: _BackBtn(bloc: bottomnNavBloc),
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
  _BackBtn({Key key, this.bloc}) : super (key: key);

  final BottomNavBarBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.page,
      builder: (context, snapshot) {
        return _btn(bloc);
      },
    );
  }

  Widget _btn(BottomNavBarBloc bloc) {  
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
      onPressed: () => bloc.switchPage(Pages.calendar),
    );
  }
}

Widget _headerDate(BottomNavBarBloc bloc) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20.0),
    child: StreamBuilder(
      stream: bloc.date,
      builder: (context, snapshot) {
        return Text(
          DateFormat.yMMMMd().format(bloc.getDate()),
          style: mainTheme.textTheme.body1,
        );
      },
    ),
  );
}