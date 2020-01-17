import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler/bloc/task/task_event.dart';
import 'package:scheduler/bloc/todo/todo_event.dart';

import 'package:scheduler/customTemplates/export.dart';
import 'package:scheduler/data/dbManager.dart';

import 'package:scheduler/data/models.dart';

import 'addEditTaskScreen.dart';

enum Type{Category, Task}

class SearchScreen extends StatelessWidget {
  SearchScreen({Key key, this.list, this.type, this.bloc}) : super (key: key);

  final List<Object> list;
  final Type type;
  final Object bloc;

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
      default: return _catContent();
    }
  }

  Widget _catContent() {
    return SearchContent(
      title: 'Category',
      list: list,
      newString: (string) => 'Create new category : $string',
      newCallback: (string, context, formBloc) async {
        final newCat = Category.newCategory(string);
        Category cat = new Category(await formBloc.addNewCat(newCat), newCat.name);
        Navigator.of(context).pop(cat);
      },
      visibleToggle: (i, search) => i.name.contains(search),
      tileContent: (i) => Text(i.name, style: mainTheme.textTheme.body1),
    );
  }

  Widget _taskContent() {
    return SearchContent(
      title: 'Task',
      list: list,
      newString: (string) => 'Create new task $string',
      newCallback: (string, context, formBloc) async {
        final newTask = new Task.newTask(string, '');

        // final DbManager dbManager = DbManager.instance;
        // final taskId = 
    // final rel = await dbManager.getTaskCategory(task.id);
    // final cat = await dbManager.getCateogry(rel.categoryID);

    // Navigator.push(context, CupertinoPageRoute(
                // builder: (_) => AddEditTaskScreen(isEditing: true, task: task, category: cat, taskBloc: BlocProvider.of<TaskBloc>(context),)));
        final task = await Navigator.push(context, CupertinoPageRoute(
          builder: (_) => AddEditTaskScreen(taskBloc: bloc, isEditing:  false, title: string)));
        
        if (task!=null)
          Navigator.of(context).pop(task);
      },
      visibleToggle: (i, search) => i.name.contains(search),
      tileContent: (i) => Text(i.name, style: mainTheme.textTheme.body1),
    );
  }
}