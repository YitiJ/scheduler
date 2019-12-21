import 'package:flutter/material.dart';

import 'package:scheduler/data/models.dart';
import 'package:scheduler/customTemplates/themes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/navBar/navbar.dart';
import 'package:scheduler/bloc/segmentedControl/segmentedControl_bloc.dart';

import 'package:intl/intl.dart';
import 'package:scheduler/screens/schedule/todoScreen.dart';

import 'timelineScreen.dart';
import 'segmentedControl.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key, this.date}) : super (key: key);

  final DateTime date;

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
          _headerNav(_segmentedControlBloc),
          _headerDate(widget.date),

          StreamBuilder<Option>(
            stream: _segmentedControlBloc.segmentStream,
            initialData: _segmentedControlBloc.defaultOption,
            builder: (BuildContext context, AsyncSnapshot<Option> snapshot) {
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

Widget _headerNav(SegmentedControlBloc _bloc) {
  return Stack(
    children: <Widget>[
      Positioned(
        left: 0,
        child: _BackBtn(),
      ),
      
      StreamBuilder(
        stream: _bloc.segmentStream,
        initialData: _bloc.defaultOption,
        builder: (BuildContext context, AsyncSnapshot<Option> snapshot) {
          return SegmentedControl(curInd: snapshot.data, bloc: _bloc);
        }
      ),
    ],
  );
}

class BackBtnBloc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      condition: (previousState, state) =>
          state.runtimeType != previousState.runtimeType,
      builder: (context, state) => _BackBtn(),
    );
  }
}
    
class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _mapStateToActionButtons(
      navBarBloc: BlocProvider.of<NavBarBloc>(context));
  }

  Widget _mapStateToActionButtons({
    NavBarBloc navBarBloc,
  }) {
    return _btn( navBarBloc );
  }

  Widget _btn(NavBarBloc navBarBloc) {  
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
      onPressed: () => navBarBloc.add(CalendarEvent()),
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