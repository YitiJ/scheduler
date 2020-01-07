import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler/data/dbManager.dart';

import 'package:scheduler/bloc/task/task.dart';

import 'searchScreens.dart';

import 'package:scheduler/customTemplates/customWidgets.dart';
import 'package:scheduler/customTemplates/themes.dart';

class AddTodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _header(context),

        _Content(),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          child: backBtn(() => Navigator.pop(context)),
        ),
        
        Text(
          'Add Todo',
          style: mainTheme.textTheme.body1,
        )
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final DbManager dbManager = DbManager.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Task:',
          style: mainTheme.textTheme.body2,
        ),
        Spacer(),
        StreamBuilder(   
          stream: bloc.task,
          builder: (context, snapshot) {
            return FlatButton(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Text(
                      bloc.getTask().name,
                      style: mainTheme.textTheme.body1,
                    ),
                  ),
                  Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                ],
              ),
              onPressed: () async {
                final _tasks = await dbManager.getAllTask();

                final _task = await Navigator.push(context, CupertinoPageRoute(
                    builder: (_) => SearchScreen(type: Type.Task, list: _tasks, bloc: BlocProvider.of<TaskBloc>(context))));
                
                if (_task == null) return;

                bloc.addTask(_task);
              },
            );
          },
        ),
      ],
    ); 
  }
}