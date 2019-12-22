

import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/colours.dart';
import 'package:scheduler/data/models.dart';

typedef OnDeleteCallBack = void Function(BuildContext context, DbModel item);
typedef OnEditCallBack = void Function(BuildContext context, DbModel item);

class CustomList extends StatelessWidget{
  final OnEditCallBack onEdit;
  final OnDeleteCallBack onDelete;
  List<List<Widget>> content;

  List<DbModel> models;

  CustomList({@required this.models, @required this.content, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context){
    return new ListView.builder(
      itemCount: content.length + 1,
      itemBuilder: (BuildContext context, int index){
        if(index >= content.length) return Container(height: 200, width: 1); //so that it can access the lowest element :<
        return new _TableRow(models[index], content[index],this.onEdit, this.onDelete);
      },
    );
  }
}

class _TableRow extends StatelessWidget{

  List<Widget> content;
  DbModel model;
  final OnEditCallBack onEdit;
  final OnDeleteCallBack onDelete;
  _TableRow(this.model, this.content,this.onEdit,this.onDelete);
  @override
  Widget build(BuildContext context){
    
    return Stack(
      children: <Widget>[
Align(
              alignment: Alignment.centerLeft,
              child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,),
          ),
        
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
          children:<Widget>[
            IconButton(
              icon: new Icon(Icons.edit, color: Colors.white,),
              highlightColor: purple,
              onPressed: ()=> onEdit(context,model),
              
            ),
            IconButton(
          icon: new Icon(Icons.delete, color: Colors.white,),
          highlightColor: purple,
          onPressed: ()=> onDelete(context, model),
        )
        ],))
      ]);
  }
}