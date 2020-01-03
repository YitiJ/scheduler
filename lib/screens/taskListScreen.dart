import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/customTemplates/customWidgets.dart';
import 'package:scheduler/customTemplates/loadingIndicator.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/screens/addEditTaskScreen.dart';

typedef OnAddCallBack = Function();

class TaskListScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => TaskBloc(dbManager: DbManager.instance)..add(LoadTask()),
      child:BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state){
          List<Task> models = new List<Task>();
          Widget content;
          if(state is TaskLoading){
            return LoadingIndicator();
          }
          else if (state is TaskLoaded){
            state.tasks.forEach(
                (task) => models.add(task)
              );
            content = _taskList(context, models);
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
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Saved Task",
                    style: Theme.of(context).textTheme.subtitle,))]
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    content,

                    Positioned(
                      right: 15.0,
                      bottom: 25.0,
                      child: ThemedButton(
                        icon: Icon(Icons.add),
                        size: 70.0,
                        callback: () => _onAdd(context)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ));
  }

  void _onAdd(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
                builder: (_) => AddEditTaskScreen(taskBloc: BlocProvider.of<TaskBloc>(context))));
  }
  void _onDelete(BuildContext context, Task task){
    BlocProvider.of<TaskBloc>(context).add(DeleteTask(task.id));
  }
  void _onEdit(BuildContext context, Task task){
    Navigator.push(context, CupertinoPageRoute(
                builder: (_) => AddEditTaskScreen(isEditing: true, task: task as Task, taskBloc: BlocProvider.of<TaskBloc>(context),)));
  }

  Widget _taskList(BuildContext context, List<Task> tasks){
    return new ListView.builder(
      padding: EdgeInsets.all(15.0),

      itemCount: tasks.length + 1,
      itemBuilder: (BuildContext context, int index){
        if(index >= tasks.length) return Container(height: 200, width: 1); //so that it can access the lowest element :<
        return _tableRow(context, tasks[index]);
      },
    );
  }

  Widget _tableRow (BuildContext context, Task task){
    return Stack(
      alignment: Alignment.center,

      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(task.name),

              task.description != null && task.description.length > 0 ? Padding( padding: EdgeInsets.only(top: 5.0), ) : Container(height: 0, width: 0),

              task.description != null && task.description.length > 0 ? Text('\t\t${task.description}') : Container(height: 0, width: 0),
            ],
          ),
        ),
        
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children:<Widget>[
              IconButton(
                icon: new Icon(Icons.edit, color: Colors.white,),
                highlightColor: Colors.purple,
                onPressed: () => _onEdit(context,task),
                
              ),
              IconButton(
                icon: new Icon(Icons.delete, color: Colors.white,),
                highlightColor: Colors.purple,
                onPressed: ()=> _onDelete(context, task),
              )
            ],
          ),
        )
      ],
    );
  }
}

