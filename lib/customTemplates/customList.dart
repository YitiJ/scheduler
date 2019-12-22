

import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/colours.dart';

typedef OnDeleteCallBack = Function(BuildContext context, int id);
typedef OnEditCallBack = Function(BuildContext context, int id);

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
        return new _TableRow(ids[index], content[index],this.onEdit, this.onDelete);
      },
    );
  }
}

class _TableRow extends StatelessWidget{

  List<Widget> content;
  int id;
  final OnEditCallBack onEdit;
  final OnDeleteCallBack onDelete;
  _TableRow(this.id, this.content,this.onEdit,this.onDelete);
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