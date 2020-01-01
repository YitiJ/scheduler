import 'package:flutter/material.dart';

import 'package:scheduler/customTemplates/export.dart';

import 'package:scheduler/data/models.dart';

class CatSearchScreen extends StatelessWidget {
  CatSearchScreen({Key key, this.cats}) : super (key: key);

  final List<Category> cats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutTemplate.getPageWidget(content(), null),
    );
  }

  Widget content() {
    return SearchContent(
      list: cats,
      newCallback: (string, context, bloc) {
        final newCat = Category.newCategory(string, 0);
        bloc.addNewItem(newCat);
        Navigator.of(context).pop(newCat);
      },
      visibleToggle: (i, search) => i.name.contains(search),
      tileContent: (i) => Text(i.name, style: mainTheme.textTheme.body1),
    );
  }
}