import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scheduler/data/models/task.dart';
import 'package:intl/intl.dart';

import 'package:scheduler/bloc/taskForm/taskForm.dart';

import 'package:scheduler/customTemplates/colours.dart';

class CreateTaskScreen extends StatelessWidget{
  CreateTaskScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _headerNav(context),
        _header(context),
        _formContainer(),
      ],
    );
  }

  Widget _headerNav(BuildContext context) {
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
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'BACK',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
        ),
        FlatButton(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: Text(
                  'SAVE',
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              Icon(
                Icons.done,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create Task',
          style: Theme.of(context).textTheme.body1,
        ),
      ],
    );
  }

  Widget _formContainer() {
    return Provider(
      child: _Form(),
    );
  }
}

class _Form extends StatefulWidget {
  _Form({Key key}) : super(key: key);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          titleField(bloc),
          noteField(bloc),
          dateField(bloc),
          timeField(bloc),
          passwordField(bloc),
          Container(
            margin: EdgeInsets.only(top: 25.0),
          ),
          submitButton(bloc),
        ],
      ),
    );
  }

  Widget titleField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.title,
      builder: (context, snapshot) {
        return TextField(
          style: Theme.of(context).textTheme.body1,
          onChanged: bloc.changeTitle,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Title',
            labelText: 'Title',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget noteField(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.note,
      builder: (context, snapshot) {
        return TextField(
          style: Theme.of(context).textTheme.body1,
          onChanged: bloc.changeNote,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Note',
            labelText: 'Note',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget dateField(Bloc bloc) {
    final dateFormat = DateFormat.yMMMd();

    return Row(
      children: [
        Text(
          'Select Date:',
          style: Theme.of(context).textTheme.body2,
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
                      style: Theme.of(context).textTheme.body1,
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
            style: Theme.of(context).textTheme.body2,
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
                        style: Theme.of(context).textTheme.body1,
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

  Widget passwordField(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            style: Theme.of(context).textTheme.body1,
            obscureText: true,
            onChanged: bloc.changePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              errorText: snapshot.error,
            ),
          );
        });
  }

  Widget submitButton(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          color: Colors.blue,
          onPressed: snapshot.hasData ? bloc.submit : null,
        );
      },
    );
  }
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