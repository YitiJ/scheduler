import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:scheduler/customTemplates/export.dart';

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
      newString: (string) => 'Create new task',
      newCallback: (string, context, formBloc) async {        
        final task = await Navigator.push(context, CupertinoPageRoute(
          builder: (_) => AddEditTaskScreen(taskBloc: bloc,)));

          // print('search pop: ${task.name}');
        if (task == null) return;

        Navigator.of(context).pop(task);
      },
      visibleToggle: (i, search) => i.name.contains(search),
      tileContent: (i) => Text(i.name, style: mainTheme.textTheme.body1),
    );
  }
}