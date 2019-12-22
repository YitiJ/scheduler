import 'package:flutter/material.dart';

import 'package:scheduler/customTemplates/themes.dart';

import 'package:scheduler/bloc/catSearch/catSearch.dart';

class CatSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Search Category',
          style: mainTheme.textTheme.body1,
        ),
        Provider(
          child: SearchBar(),
        ),
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
    final bloc = Provider.of(context);

    return Container(
      child: StreamBuilder(
        stream: bloc.search,
        builder: (context, snapshot) {
          return TextField(
            // controller: editingController
            style: mainTheme.textTheme.body1,
            onChanged: bloc.updateSearch,
            keyboardType: TextInputType.text,
            
            decoration: InputDecoration(
              // labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            ),
          );
        },
      ),
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