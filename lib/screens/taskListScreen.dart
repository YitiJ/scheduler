import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scheduler/bloc/task/task.dart';
import 'package:scheduler/bloc/task/task_state.dart';
import 'package:scheduler/customTemplates/colours.dart';
import 'package:scheduler/data/dbManager.dart';

class TaskListScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return BlocProvider(
      create: (context) => TaskBloc(dbManager: DbManager.instance)..add(LoadTask()),
      child:BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state){
          List<List<Widget>> contents = new List<List<Widget>>();
          if(state is TaskLoading){
            return Card(color: Colors.white,);
          }
          else if (state is TaskLoaded){
            state.tasks.forEach(
                (task) => contents.add(<Widget>[
                  Text(task.name),
                  Text((task.description == null) ? "" : task.description)])
              );
            return CustomList(contents);
          }
          else if (state is TaskNotLoaded){
            return Container(height: 0.00, width: 0.00,);
          }
        }
      ));
  }

}

class CustomList extends StatelessWidget{

  List<List<Widget>> content;

  CustomList(this.content);

  @override
  Widget build(BuildContext context){
    return new ListView.builder(
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index){
        return new TableRow(content[index]);
      },
    );
  }
}

class TableRow extends StatelessWidget{

  List<Widget> content;
  TableRow(this.content);
  @override
  Widget build(BuildContext context){
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,),
        Container(margin: EdgeInsets.only(left: 200),),
        IconButton(
          icon: new Icon(Icons.edit, color: Colors.white,),
          highlightColor: purple,
          onPressed: ()=> null,
          
        ),
        IconButton(
          icon: new Icon(Icons.delete, color: Colors.white,),
          highlightColor: purple,
          onPressed: ()=> null,
        )
      ],
    );
  }
}