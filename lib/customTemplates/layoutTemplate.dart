import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/screens/catSearchScreen.dart';
import 'package:scheduler/screens/createTaskScreen.dart';
import 'package:scheduler/screens/taskListScreen.dart';
import 'themes.dart';
import 'navBar.dart';

import 'package:scheduler/screens/timerScreen.dart';
import 'package:scheduler/screens/calendarScreen.dart';
import 'package:scheduler/screens/schedule/scheduleScreen.dart';

import 'package:scheduler/bloc/navBar/navbar_bloc.dart';

class LayoutTemplate extends StatefulWidget {
  _LayoutTemplateState createState() => _LayoutTemplateState();
}

class _LayoutTemplateState extends State<LayoutTemplate> {
  final BottomNavBarBloc _bottomNavBarBloc = BottomNavBarBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.transparent,
      body: Page(_bottomNavBarBloc),
    );
  }
}

Widget Page(BottomNavBarBloc _bloc) {
  return Stack(
    children: [
      Positioned.fill(
        child: Container(
          decoration: backgroundGradient(),

          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
                  child: StreamBuilder(
                    stream: _bloc.page,
                    builder: (context, snapshot) {
                        final pages = [TimerScreen(), CalendarScreen(bloc: _bloc), ScheduleScreen(bloc: _bloc), TaskListScreen(onEdit: (context,id){print("edit");},onDelete: (context,id) {print("delete");BlocProvider.of<TaskBloc>(context).add(DeleteTask(id));},), CreateTaskScreen()];
                        switch(_bloc.getPage()) {
                          case Pages.timer:
                            return pages[0];
                          case Pages.calendar:
                            return pages[1];
                          case Pages.schedule:
                            return pages[2];
                          case Pages.taskList:
                            return pages[3];
                          case Pages.newTask:
                            return pages[4];
                          default:
                            return pages[0];
                        }
                      },
                    ),
                ),
              ),

              NavBar(bloc: _bloc),
            ],
          ),
        ),
      ),
    ],
  );
}