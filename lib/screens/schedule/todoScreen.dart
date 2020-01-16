import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/todo/todo.dart';

import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/data/models/todo.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/customTemplates/loadingIndicator.dart';
import 'package:scheduler/helper.dart';
import 'package:scheduler/screens/addTodo.dart';

class TodoScreen extends StatelessWidget {

  final DateTime date;
  TodoScreen(this.date);

  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(dbManager: DbManager.instance)..add(LoadTodo(date)),
      
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
          final Todo newTodo = await Navigator.push(context, CupertinoPageRoute(
            builder: (_) => AddTodoScreen(date: Helper.getStartDate(date))));

          if (newTodo == null)
            return;
          bloc.add(AddTodo(newTodo,Helper.getStartDate(this.date)));
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
    return FutureBuilder<Task>(
      future: _getTask(todo.taskID),
      builder: (context, snapshot) {

        if(snapshot.hasData == false)
          return Container();

        final _task = snapshot.data;

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
                  final updateTodo = Todo.fromMap(todo.toMap()); //make a copy of the todo that is reference from the state from TodoBloc
                  updateTodo.completed = !updateTodo.completed;
                  bloc.add(UpdateTodo(updateTodo,date));
                },
              ),

              Padding(
                padding: EdgeInsets.only(left: 10.0),

                child: FutureBuilder(
                  future: _getTimeString(todo),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) return Container();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _task.name,
                            style: mainTheme.textTheme.body1,
                            textAlign: TextAlign.left,
                          ),
                        ),

                        Text(
                          snapshot.data,
                          // '${TimeOfDay.now().hour % 12}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().hour <= 12 ? 'AM' : 'PM'}',
                          style: mainTheme.textTheme.body1,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children:<Widget>[
              IconButton(
                icon: new Icon(Icons.edit, color: Colors.white,),
                highlightColor: Colors.purple,
                onPressed: () async {
                  final Todo newTodo = await Navigator.push(context, CupertinoPageRoute(
                    builder: (_) => AddTodoScreen(date: Helper.getStartDate(date),isEditing: true, todo: todo,task: _task,)));

                  if (newTodo == null)
                    return;
                  bloc.add(UpdateTodo(newTodo,Helper.getStartDate(this.date)));
                },
                
              ),
              IconButton(
                icon: new Icon(Icons.delete, color: Colors.white,),
                highlightColor: Colors.purple,
                onPressed: ()=> _onDelete(context, todo),
              )
            ],
          ),
          onTap: () async => showAlertDialog(context, todo, _task),
        );
      },
    );
  }
}

showAlertDialog(BuildContext context, Todo todo, Task task) {
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
            child: FutureBuilder(
              future: _getCat(task),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container();

                return Text(
                  snapshot.data.name,
                  style: mainTheme.textTheme.body1,
                );
              },
            ),
          ),
          Text(
            'NOTE: ${task.description}',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          ),
          Padding(padding: EdgeInsets.all(5),),
          Text(
            'DATE: ${DateFormat.yMMMd().format(DateTime.now())}',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          ),
          Padding(padding: EdgeInsets.all(5),),
          Text(
            'TIME SPENT: ${_getTime(todo.duration)}',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          )
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

void _onDelete(BuildContext context,Todo todo){
   BlocProvider.of<TodoBloc>(context).add(DeleteTodo(todo.id));
}

// Returns the task given its id
Future<Task> _getTask(int id) async {
  return await DbManager.instance.getTask(id);
}

// Returns a string of the set and timed duration
Future<String> _getTimeString(Todo todo) async {
  return _getTime(todo.duration) + ' | ' + await _getDuration(todo);
}

// Returns a string of the set duration of the task
String _getTime(int dur) {
  final String seconds = (dur % 60).toString().padLeft(2, '0');
  final String minutes = ((dur / 60) % 60).floor().toString().padLeft(2, '0');
  final int hours = (dur / 60 / 60).floor();

  return '${hours > 0 ? hours.toString() + 'h ' : ''}${minutes}m ${seconds}s';
}

// Returns a string of the current timed duration of the task
Future<String> _getDuration(Todo todo) async {
  final int taskId = todo.taskID;
  final startTime = Helper.getStartDate(todo.date);
  final endTime = Helper.getEndDate(todo.date);
  final taskHistoryList = await DbManager.instance.getTaskHistorysByTaskDate(startTime, endTime, taskId);

  final int duration = Helper.getTaskHisDuration(taskHistoryList);

  return _getTime(duration);
}

// Returns the category of the task
Future<Category> _getCat(Task task) async {
  final DbManager dbManager = DbManager.instance;
  final catRel = await dbManager.getTaskCategory(task.id);

  return await dbManager.getCateogry(catRel.categoryID);
}