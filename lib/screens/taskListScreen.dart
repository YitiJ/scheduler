import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/bloc/task/task_state.dart';
import 'package:scheduler/customTemplates/customList.dart';
import 'package:scheduler/customTemplates/loadingIndicator.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/screens/addEditTaskScreen.dart';

typedef OnAddCallBack = Function();

class TaskListScreen extends StatelessWidget{
  TaskListScreen();
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => TaskBloc(dbManager: DbManager.instance)..add(LoadTask()),
      child:BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state){
          List<List<Widget>> contents = new List<List<Widget>>();
          List<DbModel> models = new List<DbModel>();
          Widget content;
          if(state is TaskLoading){
            return LoadingIndicator();
          }
          else if (state is TaskLoaded){
            state.tasks.forEach(
                (task) {
                  contents.add(<Widget>[
                    Text(task.name),
                    Text((task.description == null) ? "" : task.description)]);
                  models.add(task);}
              );
            content = CustomList(models: models, content: contents,onEdit: onEdit,onDelete: onDelete);
          }
          else if (state is TaskNotLoaded){
            content = Container(height: 0.00, width: 0.00,);
          }
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Saved Task",
                    style: Theme.of(context).textTheme.body1,))]
              ),
              Expanded(child: content),
            ]
          );
        }
      ));
  }

  void onDelete(BuildContext context, DbModel task){
    BlocProvider.of<TaskBloc>(context).add(DeleteTask(task.id));
  }

  void onEdit(BuildContext context, DbModel task){
    Navigator.push(context, CupertinoPageRoute(
                builder: (_) => AddEditTaskScreen(isEditing: true, task: task as Task, taskBloc: BlocProvider.of<TaskBloc>(context),)));
  }
}

