import 'package:flutter/material.dart';
import 'colours.dart';
import 'navBar.dart';

import 'package:scheduler/screens/timerScreen.dart';
import 'package:scheduler/screens/calendarScreen.dart';
import 'package:scheduler/screens/schedule/scheduleScreen.dart';
import 'package:scheduler/screens/createTaskScreen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/bloc/navBar/navBar.dart';

class LayoutTemplate extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.transparent,
      body: BlocProvider(
        create: (context) => NavBarBloc(),
        child: Page(),
      ),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [darkRed[700], orange[700]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),

            child : Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
                    child: BlocBuilder<NavBarBloc, NavBarState>(
                        builder: (context, state) {
                          final pages = [TimerScreen(), CalendarScreen(), ScheduleScreen(date: state.date)];
                          
                          return pages[state.index];
                        },
                      ),
                  ),
                ),

                NavBar(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}