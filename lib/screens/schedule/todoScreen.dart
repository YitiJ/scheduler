import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/todo/todo.dart';

import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/data/models/todo.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/customTemplates/loadingIndicator.dart';
import 'package:scheduler/screens/addTodo.dart';

class TodoScreen extends StatelessWidget {
  // TodoScreen({Key key, this.list}) : super (key: key);

  // final List<Todo> list;
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(dbManager: DbManager.instance)..add(LoadTodo()),
      
      child: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          List<Todo> models = new List<Todo>();
          Widget content;

          if(state is TodoLoading){
            return LoadingIndicator();
          }
          else if (state is TodoLoaded){
            state.todo.forEach(
                (todo) => models.add(todo)
              );

            content = Stack(
              children:[
                listView(models),
            
                _button(context, BlocProvider.of<TodoBloc>(context)),
              ],
            );
          }
          else if (state is TaskNotLoaded){
            content = Container(height: 0.00, width: 0.00,);
          }

          return content;
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

  ListView listView(List<Todo> models) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0.0),

      itemCount: models.length,
      itemBuilder: (context, index) {
        return todoItem(context, models[index], BlocProvider.of<TodoBloc>(context));
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
            checkColor: Colors.white,
            //focusColor: Colors.white,
            value: todo.completed,
            onChanged: (_) {
              print('Current: ${todo.id} ${todo.taskID} ${todo.completed}');
              todo.completed = !todo.completed;
              print('New: ${todo.id} ${todo.taskID} ${todo.completed}');
              // print('New: ${t.completed}');
              bloc.add(UpdateTodo(todo));
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