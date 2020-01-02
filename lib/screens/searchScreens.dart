import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/customTemplates/export.dart';

import 'package:scheduler/data/models.dart';

import 'addEditTaskScreen.dart';
import 'package:scheduler/bloc/task/task.dart';

enum Type{Category, Task}

class searchScreen extends StatelessWidget {
  searchScreen({Key key, this.list, this.type}) : super (key: key);

  final List<Object> list;
  final Type type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutTemplate.getPageWidget(_getContent(), null),
    );
  }

  Widget _getContent() {
    switch (type) {
      case Type.Category:
        return _catContent();
        break;
      case Type.Task:
        return _taskContent();
        break;
      default: _catContent();
    }
  }

  Widget _catContent() {
    return SearchContent(
      title: 'Category',
      list: list,
      newCallback: (string, context, bloc) {
        final newCat = Category.newCategory(string, 0);
        bloc.addNewItem(newCat);
        Navigator.of(context).pop(newCat);
      },
      visibleToggle: (i, search) => i.name.contains(search),
      tileContent: (i) => Text(i.name, style: mainTheme.textTheme.body1),
    );
  }

  Widget _taskContent() {
    return SearchContent(
      title: 'Task',
      list: list,
      newCallback: (string, context, bloc) {
        final newTask = Task.newTask(string, "");
        
        Navigator.push(context, CupertinoPageRoute(
          builder: (_) => AddEditTaskScreen(isEditing: true, task: newTask as Task, taskBloc: BlocProvider.of<TaskBloc>(context),)));
      },
      visibleToggle: (i, search) => i.name.contains(search),
      tileContent: (i) => Text(i.name, style: mainTheme.textTheme.body1),
    );
  }
}