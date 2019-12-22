import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/bloc/task/task_state.dart';
import 'package:scheduler/customTemplates/colours.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';

typedef OnDeleteCallBack = Function(BuildContext context, int id);
typedef OnEditCallBack = Function(BuildContext context, int id);
typedef OnAddCallBack = Function();

class TaskListScreen extends StatelessWidget{
  OnDeleteCallBack onDelete;
  OnEditCallBack onEdit;
  OnAddCallBack onAdd;
  TaskListScreen({this.onAdd, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Saved Task",
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.center,
          ),
        ),
        taskList(),
      ],
    );
  }

  Widget taskList(){
    return Container(
      child: BlocProvider(
        create: (context) => TaskBloc(dbManager: DbManager.instance)..add(LoadTask()),
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state){
            List<List<Widget>> contents = new List<List<Widget>>();
            List<int> ids = new List<int>();
            Widget content;
            if(state is TaskLoading){
              content = Card(color: Colors.white,);
            }
            else if (state is TaskLoaded){
              state.tasks.forEach(
                  (task) {
                    contents.add(<Widget>[
                      Text(task.name),
                      Text((task.description == null) ? "" : task.description)]);
                    ids.add(task.id);}
                );
              content = CustomList(ids: ids, content: contents,onEdit: onEdit,onDelete: onDelete);
            }
            else if (state is TaskNotLoaded){
              content = Container(height: 0.00, width: 0.00,);
            }

            return Expanded(child: content);
          },
        ),
      ),
    );
  }
}

class CustomList extends StatelessWidget{
  final OnEditCallBack onEdit;
  final OnDeleteCallBack onDelete;
  List<List<Widget>> content;

  List<int> ids;

  CustomList({@required this.ids, @required this.content, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context){
    return new ListView.builder(
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index){
        return new TableRow(ids[index], content[index],this.onEdit, this.onDelete);
      },
    );
  }
}

class TableRow extends StatelessWidget{
  List<Widget> content;
  int id;
  final OnEditCallBack onEdit;
  final OnDeleteCallBack onDelete;
  TableRow(this.id, this.content,this.onEdit,this.onDelete);
  @override
  Widget build(BuildContext context){
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,),
        Container(margin: EdgeInsets.only(left: 200),),
        IconButton(
          icon: new Icon(Icons.edit, color: Colors.white,),
          highlightColor: purple,
          onPressed: ()=> onEdit(context, id),
          
        ),
        IconButton(
          icon: new Icon(Icons.delete, color: Colors.white,),
          highlightColor: purple,
          onPressed: ()=> onDelete(context, id),
        )
      ],
    );
  }
}