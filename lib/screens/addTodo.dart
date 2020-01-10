import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:scheduler/data/dbManager.dart';

import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/bloc/todoForm/todoForm.dart';

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
                _SelectTask(bloc: bloc),

                SizedBox(height: 15.0),

                _CalendarDate(bloc: bloc),

                SizedBox(height: 15.0),

                _DurationPicker(bloc: bloc),
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
                // bloc.submit();
                Navigator.pop(context, bloc.submit());
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
                  print('todo: ${_task.name}');
                  if (_task == null) return;

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

class _CalendarDate extends StatelessWidget {
  _CalendarDate({Key key, @required this.bloc}) : super(key: key);

  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    return Row(
      children: [
        Text(
          'Select Date:',
          style: mainTheme.textTheme.body2,
        ),
        Spacer(),
        StreamBuilder(   
          stream: bloc.date,
          builder: (context, snapshot) {
            return FlatButton(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      dateFormat.format(bloc.getDate()),
                      style: mainTheme.textTheme.body1,
                    ),
                  ),
                  Icon(
                    Icons.date_range,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () async {
                final _date = await _datePicker(context);
                if (_date == null) return;

                bloc.addDate(_date);
              },
            );
          },
        ),
      ],
    ); 
  }
}

class _DurationPicker extends StatelessWidget {
  _DurationPicker({Key key, @required this.bloc}) : super (key: key);

  final Bloc bloc;

  Duration dur;

  Future<Duration> _showDialog(context) async {
    return await showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: mainTheme.copyWith(
            textTheme: TextTheme(
              body1: TextStyle(color: purple),
              subhead: TextStyle(color: purple),

              button: TextStyle(color: purple),
              caption: TextStyle(color: purple),
            ),
          ),

          child: Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  _DatePickerHeader(selectedDate: DateTime.now(),),

                  _picker(bloc, context),

                  actions(context),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
  
  Widget _picker(bloc, context) {
    return CupertinoTimerPicker(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      initialTimerDuration: bloc.getDuration(),
      onTimerDurationChanged: (Duration newTimer) {
        dur = newTimer;
      },
    );
  }

  Widget actions(context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,

      child: ButtonBar(
        children: <Widget>[
          FlatButton(
            child: Text(localizations.cancelButtonLabel, style: mainTheme.textTheme.button.copyWith(color: purple)),
            onPressed: () => Navigator.pop(context),
          ),
          FlatButton(
            child: Text(localizations.okButtonLabel, style: mainTheme.textTheme.button.copyWith(color: purple)),
            onPressed: () => Navigator.pop(context, dur),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration d) {
    String hours = d.inHours > 0 ? d.inHours.toString() + 'h' : '';
    String minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    
    return '$hours ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Select Duration:',
          style: mainTheme.textTheme.body2,
        ),
        Spacer(),
    
        StreamBuilder(   
          stream: bloc.duration,
          builder: (context, snapshot) {
            return FlatButton(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      '${bloc.getDuration() == null ? 0 : formatDuration(bloc.getDuration())}',
                      style: mainTheme.textTheme.body1,
                    ),
                  ),
                  Icon(
                    Icons.timer,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () async {
                final _duration = await _showDialog(context);
                if (_duration == null) return;

                print(_duration);

                bloc.addTime(_duration);
              },
            );
          },
        ),
      ],
    );
  }
}

class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    Key key,
    @required this.selectedDate,
  }) : assert(selectedDate != null),
       super(key: key);

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    
    final ThemeData theme = Theme.of(context);
    final TextTheme headerTextTheme = theme.primaryTextTheme;
    
    final TextStyle dayStyle = headerTextTheme.display1.copyWith(color: Colors.white);
    final TextStyle yearStyle = headerTextTheme.subhead.copyWith(color: Colors.white);
    
    final Color backgroundColor = theme.backgroundColor;

    final EdgeInsets padding = const EdgeInsets.all(16.0);
    final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center;

    final Widget yearButton = Container(
      color: backgroundColor,
      child: Text(localizations.formatYear(selectedDate), style: yearStyle),
    );

    final Widget dayButton = Container(
      color: backgroundColor,
      child: Text(localizations.formatMediumDate(selectedDate), style: dayStyle),
    );

    return Container(
      padding: padding,
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          yearButton,
          dayButton,
        ],
      ),
    );
  }
}

// class _Duration extends StatelessWidget {
//   _Duration({Key key, @required this.bloc}) : super(key: key);

//   final Bloc bloc;

//   Widget build(BuildContext context) {
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

Future<DateTime> _datePicker(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2018),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: mainTheme.copyWith(
          textTheme: TextTheme(
            body1: TextStyle(color: purple),
            subhead: TextStyle(color: purple),

            button: TextStyle(color: purple),
            caption: TextStyle(color: purple),
          ),
        ),
        child: child,
      );
    },
  );
  // return picked;
}

// String _formatTimeOfDay(TimeOfDay t) {
//     final now = new DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
//     final format = DateFormat.jm();  //"6:00 AM"
//     return format.format(dt);
// }