import 'package:flutter/material.dart';
import 'package:scheduler/screens/scheduleScreen.dart';
import 'colours.dart';
import 'navBar.dart';

import 'package:scheduler/screens/timerScreen.dart';
import 'package:scheduler/screens/calendarScreen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/bloc/navBar/navBar.dart';

class LayoutTemplate extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: BlocProvider(
        create: (context) => NavBarBloc(),
        child: Page(),
        
      ),
    );
  }
}

class Page extends StatelessWidget {
  final pages = [TimerScreen(), CalendarScreen()];

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
            
            child: BlocBuilder<NavBarBloc, NavBarState>(
              builder: (context, state) {
                return pages[state.index];
              },
            ),
            // child: TimerScreen(), // Current Screen displayed
          ),
        ),

        NavBar(index: 0),
      ],
    );
  }
}