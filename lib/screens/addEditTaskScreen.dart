import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/customTemplates/layoutTemplate.dart';
import 'package:scheduler/customTemplates/themes.dart';
import 'package:scheduler/data/models/task.dart';
import 'package:intl/intl.dart';
import 'package:scheduler/bloc/taskForm/taskForm.dart';
import 'package:scheduler/customTemplates/colours.dart';

class AddEditTaskScreen extends StatelessWidget{
  final bool isEditing;
  final Task task; // -1 is new task
  final TaskBloc taskBloc;
  static const addScreenRouteName = '/addTask';
  static const editScreenRouteName = '/editTask';
  AddEditTaskScreen({Key key, this.isEditing = false, this.task, @required this.taskBloc}):
  assert(
    isEditing? task!=null : true),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutTemplate.getPageWidget(
        Container(
          child: _formContainer(taskBloc),
        ),
        null)
    );
  }

  Widget _formContainer(TaskBloc taskBloc) {
    return Provider(
      child: _Form(isEditing: isEditing, task: task, taskBloc: taskBloc,),
    );
  }
}

class _Form extends StatefulWidget {
  final bool isEditing;
  final Task task;
  final TaskBloc taskBloc;
  _Form({Key key,this.isEditing = false,this.task = null,@required this.taskBloc}):
  assert(
    isEditing? task!=null : true),
    super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {

  bool get isEditing => widget.isEditing;
  Task get task => widget.task;
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),

      child: Column(
        children: <Widget>[
          headerNav(bloc,widget.taskBloc),
          header(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),

            child: Column(
              children: <Widget>[
                titleField(bloc),
                SizedBox(height: 15.0),
                noteField(bloc),
                
                isEditing ? Container(height:0.00,width:0.00) : _Dropdown(bloc: bloc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerNav(Bloc bloc, TaskBloc taskBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
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
        ),
        StreamBuilder(
          stream: bloc.submitValid,
          builder: (context, snapshot) {
            return FlatButton(
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
              onPressed: snapshot.hasData ? () {bloc.submit(isEditing: isEditing, task: task, bloc: taskBloc); Navigator.pop(context);} : null,
            );
          },
        )
      ],
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isEditing? 'Edit Task' : 'Create Task',
          style: mainTheme.textTheme.body1,
        ),
      ],
    );
  }

  Widget titleField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.title,
      builder: (context, snapshot) {
        return TextField(
          style: mainTheme.textTheme.body1,
          onChanged: bloc.changeTitle,
          keyboardType: TextInputType.text,
          decoration: inputStyle('Title', snapshot.error),
        );
      },
    );
  }

  Widget noteField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.note,
      builder: (context, snapshot) {
        return TextField(
          style: mainTheme.textTheme.body1,
          onChanged: bloc.changeNote,
          keyboardType: TextInputType.text,
          decoration: inputStyle('Note', snapshot.error),
        );
      },
    );
  }
}

class _Dropdown extends StatelessWidget {
  _Dropdown({Key key, @required this.bloc}) : super(key: key);

  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(   
      stream: bloc.isExpanded,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            Container (
              margin: EdgeInsets.only(top: 30.0, bottom: 15.0),

              child: FlatButton(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[
                      Text(
                        bloc.expandableHeaderText(),
                        style: mainTheme.textTheme.body1,
                      ),
                      Icon(
                        bloc.expandableHeaderIcon(),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                
                onPressed: () => bloc.toggleExpandable(),
              ),
            ),
            
            if(bloc.expandedState())
              _CalendarDate(bloc: bloc),
          ],
        );
      },
    );
  }
}

class _CalendarDate extends StatelessWidget {
  _CalendarDate({Key key, @required this.bloc}) : super(key: key);

  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column (
      children: <Widget>[
        dateField(bloc),
       
        SizedBox(height: 15.0),

        timeField(bloc),
      ],
    );
  }

  Widget dateField(Bloc bloc) {
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
                      dateFormat.format(bloc.newestDate() == null ? DateTime.now() : bloc.newestDate()),
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

  Widget timeField(Bloc bloc) {
    return Row(
      children: [
        Text(
          'Select Start Time:',
          style: mainTheme.textTheme.body2,
        ),
        Spacer(),
        StreamBuilder(   
          stream: bloc.time,
          builder: (context, snapshot) {
            return FlatButton(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      _formatTimeOfDay(bloc.newestTime() == null ? TimeOfDay.now() : bloc.newestTime()),
                      style: mainTheme.textTheme.body1,
                    ),
                  ),
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () async {
                final _time = await _timePicker(context);
                if (_time == null) return;

                bloc.addTime(_time);
              },
            );
          },
        ),
      ],
    ); 
  }
}

InputDecoration inputStyle(String text, String error) {
  return InputDecoration(
    hintText: text,
    labelText: text,
    errorText: error,
    helperStyle: mainTheme.textTheme.body2,
    hintStyle: mainTheme.textTheme.body2,
    labelStyle: mainTheme.textTheme.body2,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: purple,
      )
    )
  );
}

Future<DateTime> _datePicker(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2018),
    lastDate: DateTime(2030),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark(),
        child: child,
      );
    },
  );
  // return picked;
}

Future<TimeOfDay> _timePicker(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget child) {
      return Theme(
        data: ThemeData.dark(),
        child: child,
      );
    },
  );
  // return picked;
}

String _formatTimeOfDay(TimeOfDay t) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
}