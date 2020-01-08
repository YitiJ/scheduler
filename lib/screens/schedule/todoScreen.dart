import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/todo/todo.dart';

import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/data/models/todo.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/screens/addTodo.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({Key key, this.list}) : super (key: key);

  final List<Todo> list;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(dbManager: DbManager.instance)..add(LoadTodo(list)),
      
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return Stack(
            children:[
              listView(state),
          
              _button(context, BlocProvider.of<TodoBloc>(context)),
            ],
          );
        },
      ),
    );
  }

  Widget _button(BuildContext context, TodoBloc bloc) {
    return Positioned(
      right: 15,
      bottom: 25,
      child: ThemedButton(
        icon: Icon(Icons.add),
        size: 70.0,
        callback: () async {
          print('pressed!');
          final Task newTask = await Navigator.push(context, CupertinoPageRoute(
            builder: (_) => AddTodoScreen()));

          final Todo newTodo = Todo.newTodo(newTask.id, DateTime.now(), 1000);

          if (newTodo != null)
            bloc.add(AddTodo(newTodo));
        },
      ),
    );
  }

  ListView listView(TodoState state) {
    List<Todo> lst;

    if (state is TodoLoaded)
      lst = state.todo;

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0.0),

      itemCount: lst.length,
      itemBuilder: (context, index) {
          return BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return todoItem(context, lst[index], BlocProvider.of<TodoBloc>(context));
            },
          );
      },
    );
  }

  Widget todoItem(BuildContext context, Todo todo, TodoBloc bloc) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.white,
            //focusColor: Colors.white,
            value: todo.completed,
            onChanged: (bool newVal) {
              bloc.add(CheckBox(todo, newVal));
            },
          ),

          Padding(
            padding: EdgeInsets.only(left: 10.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    todo.taskID.toString(),
                    style: mainTheme.textTheme.body1,
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  '${TimeOfDay.now().hour % 12}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().hour <= 12 ? 'AM' : 'PM'}',
                  style: mainTheme.textTheme.body1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),

      onTap: () async => showAlertDialog(context, await DbManager.instance.getTask(todo.taskID)),
    );
  }
}

showAlertDialog(BuildContext context, Task task) {
  Widget closeBtn = FlatButton(
    child: Text(
      "OK",
      style: mainTheme.textTheme.button.copyWith(color: purple)),
    onPressed: () => Navigator.of(context).pop(),
  );

  // set up the AlertDialog
  Widget alert() {
    return AlertDialog(
      title: Text(
        task.name,
        style: mainTheme.textTheme.subtitle.copyWith(color: purple),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Tag(
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            bgColor: purple[700],
            child: Text(
              'cat',
              // task.category,
              style: mainTheme.textTheme.body1,
            ),
          ),
          Text(
            'NOTE: ${task.description}',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          ),
          Padding(padding: EdgeInsets.all(5),),
          Text(
            'TIME: ${TimeOfDay.now().hour % 12}:${TimeOfDay.now().minute} ${TimeOfDay.now().hour <= 12 ? 'am' : 'pm'}',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          ),
        ],
      ),
      actions: [
        closeBtn,
      ],
    );
  }

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert();
    },
  );
}