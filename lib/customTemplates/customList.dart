

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
      itemCount: content.length,
      itemBuilder: (BuildContext context, int index){
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
          onPressed: ()=> onEdit(context,model),
          
        ),
        IconButton(
          icon: new Icon(Icons.delete, color: Colors.white,),
          highlightColor: purple,
          onPressed: ()=> onDelete(context, model),
        )
      ],
    );
  }
}