import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';

import 'package:scheduler/customTemplates/themes.dart';

class CatSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Search Category',
          style: mainTheme.textTheme.body1,
        ),
        SearchBar(),
        Expanded(
          child: dataSource(),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(),
    );
  }
}




// Testing purposes -- create a datasource of items
ListView dataSource() {
  final items = List<String>.generate(10000, (i) => "Item $i");

  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text('${items[index]}'),
      );
    },
  );
}