import 'package:flutter/material.dart';
import 'package:scheduler/screens/scheduleScreen.dart';
import 'colours.dart';
import 'navBar.dart';

import 'package:scheduler/screens/timerScreen.dart';

class LayoutTemplate extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Stack( 
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [darkRed[700], orange[700]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            
            child: ScheduleScreen(), // Current Screen displayed
          ),
          NavBar(index: 0),
        ],
      ),
    );
  }
}