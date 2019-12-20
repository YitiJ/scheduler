import 'package:flutter/material.dart';
import 'package:scheduler/data/models/task.dart';

import 'package:scheduler/bloc/taskForm/taskForm.dart';

class CreateTaskScreen extends StatelessWidget{
  CreateTaskScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _header( context ),
        _formContainer(),
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

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          titleField(bloc),
          noteField(bloc),
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
          onChanged: bloc.changeTitle,
          keyboardType: TextInputType.emailAddress,
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
      stream: bloc.title,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeTitle,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Note',
            labelText: 'Note',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(Bloc bloc) {
    return StreamBuilder(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
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