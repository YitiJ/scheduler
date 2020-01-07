import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/data/models/category.dart';

import 'package:scheduler/data/models/task.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/screens/addTodo.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen({Key key, this.list}) : super (key: key);

  final List<Task> list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        listView(),
        
        Positioned(
          right: 15,
          bottom: 25,
          child: ThemedButton(
            icon: Icon(Icons.add),
            size: 70.0,
            callback: () {
              print('pressed!');
              Navigator.push(context, CupertinoPageRoute(
                builder: (_) => AddTodoScreen()));
            },
          ),
        ),
      ],
    );
  }

  ListView listView() {    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0.0),

      itemCount: list.length,
      itemBuilder: (context, index) {
          return todoItem(context, list[index]);
      },
    );
  }

  Widget todoItem(BuildContext context, Task task) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.white,
            //focusColor: Colors.white,
            value: false,
            onChanged: null,
          ),

          Padding(
            padding: EdgeInsets.only(left: 10.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    task.name,
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

      onTap: () => showAlertDialog(context, task),
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