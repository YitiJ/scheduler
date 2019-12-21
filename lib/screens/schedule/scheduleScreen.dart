import 'package:flutter/material.dart';

import 'package:scheduler/data/models.dart';
import 'package:scheduler/customTemplates/themes.dart';
import 'package:scheduler/customTemplates/colours.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/navBar/navbar.dart';

import 'package:intl/intl.dart';

import 'timelineScreen.dart';
import 'segmentedControl.dart';

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
      Positioned(
        left: 0,
        child: _BackBtn(),
      ),
      SegmentedControl(curInd: 0),
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