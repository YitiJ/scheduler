import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/data/dbManager.dart';

import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/bloc/todo/todo.dart';

import 'searchScreens.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/customTemplates/themes.dart';

class AddTodoScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutTemplate.getPageWidget(
        Container(
          child: _page(),
        ),
        null)
    );
  }

  Widget _page() {
    return Provider(
      child: BlocProvider<TaskBloc>(
        create: (context) => TaskBloc(dbManager: DbManager.instance)..add(LoadTask()),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return _Form();
          },
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),

      child: Column(
        children: <Widget>[
          headerNav(context, bloc),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),

            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),

                _SelectTask(bloc: bloc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerNav(BuildContext context, Bloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        backBtn(() => Navigator.pop(context)),

        Text(
          'Add Todo',
          style: mainTheme.textTheme.subtitle,
        ),

        
        StreamBuilder(
          stream: bloc.task,
          builder: (context, snapshot) {
            return FlatButton(
              // disabledColor: purple[300],
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Text(
                      'SAVE',
                      style: mainTheme.textTheme.body1,
                    ),
                  ),
                  Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: snapshot.hasData ? () {
                final _valid = bloc.getTask() != null;

                if (_valid) {
                  final _task = bloc.submit();
                  Navigator.pop(context, _task);
                }
              } : null,
            );
          },
        )
      ],
    );
  }
}

class _SelectTask extends StatelessWidget {
  _SelectTask({Key key, @required this.bloc}) : super(key: key);

  final Bloc bloc;
  final DbManager dbManager = DbManager.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: Row(
        children: <Widget>[
          Text(
            'Select Task',
            style: mainTheme.textTheme.body2,
          ),

          Spacer(),

          StreamBuilder(
            stream: bloc.task,
            builder: (context, snapshot) {
              return FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0, right: 5.0),
                      child: Text(
                        bloc.getTask() == null ? 'None' : bloc.getTask().name,
                        style: mainTheme.textTheme.body1,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                    ),
                  ],
                ),

                onPressed: () async {
                  final _tasks = await dbManager.getAllTask();

                  final _task = await Navigator.push(context, CupertinoPageRoute(
                    builder: (_) => SearchScreen(type: Type.Task, list: _tasks, bloc: BlocProvider.of<TaskBloc>(context))));
                  // if (_cat == null) return;

                  print('From search: ${_task.name}');
                  bloc.addTask(_task); 
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// class _CalendarDate extends StatelessWidget {
//   _CalendarDate({Key key, @required this.bloc}) : super(key: key);

//   final Bloc bloc;

//   @override
//   Widget build(BuildContext context) {
//     return Column (
//       children: <Widget>[
//         dateField(),
       
//         SizedBox(height: 15.0),

//         timeField(),
//       ],
//     );
//   }

//   Widget dateField() {
//     final dateFormat = DateFormat.yMMMd();

//     return Row(
//       children: [
//         Text(
//           'Select Date:',
//           style: mainTheme.textTheme.body2,
//         ),
//         Spacer(),
//         StreamBuilder(   
//           stream: bloc.date,
//           builder: (context, snapshot) {
//             return FlatButton(
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(right: 10.0),
//                     child: Text(
//                       dateFormat.format(bloc.newestDate()),
//                       style: mainTheme.textTheme.body1,
//                     ),
//                   ),
//                   Icon(
//                     Icons.date_range,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),
//               onPressed: () async {
//                 final _date = await _datePicker(context);
//                 if (_date == null) return;

//                 bloc.addDate(_date);
//               },
//             );
//           },
//         ),
//       ],
//     ); 
//   }

//   Widget timeField() {
//     return Row(
//       children: [
//         Text(
//           'Select Start Time:',
//           style: mainTheme.textTheme.body2,
//         ),
//         Spacer(),
//         StreamBuilder(   
//           stream: bloc.time,
//           builder: (context, snapshot) {
//             return FlatButton(
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.only(right: 10.0),
//                     child: Text(
//                       _formatTimeOfDay(bloc.newestTime()),
//                       style: mainTheme.textTheme.body1,
//                     ),
//                   ),
//                   Icon(
//                     Icons.access_time,
//                     color: Colors.white,
//                   ),
//                 ],
//               ),

//               onPressed: () async {
//                 final _time = await _timePicker(context);
//                 if (_time == null) return;

//                 bloc.addTime(_time);
//               },
//             );
//           },
//         ),
//       ],
//     ); 
//   }
// }

// Future<DateTime> _datePicker(BuildContext context) async {
//   return showDatePicker(
//     context: context,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2018),
//     lastDate: DateTime(2030),
//     builder: (BuildContext context, Widget child) {
//       return Theme(
//         data: ThemeData.dark(),
//         child: child,
//       );
//     },
//   );
//   // return picked;
// }

// String _formatTimeOfDay(TimeOfDay t) {
//     final now = new DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
//     final format = DateFormat.jm();  //"6:00 AM"
//     return format.format(dt);
// }