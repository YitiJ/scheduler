import 'package:flutter/material.dart';

import 'package:scheduler/customTemplates/themes.dart';

import 'package:scheduler/bloc/catSearch/catSearch.dart';

class CatSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provider(
        child: _PageContent(),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Search Category',
            style: mainTheme.textTheme.body1,
          ),
          searchBar(bloc),
          Expanded(
            child: DataSource(bloc: bloc),
          ),
        ],
      ),
    );
  }
}

Widget searchBar(Bloc bloc) {
  return Container(
    child: StreamBuilder(
      stream: bloc.search,
      builder: (context, snapshot) {
        return TextField(
          // controller: editingController
          keyboardType: TextInputType.text,
          style: mainTheme.textTheme.body1,
          onChanged: bloc.updateSearch,
          
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

class DataSource extends StatelessWidget {
  DataSource({Key key, @required this.bloc}) : super(key: key);

 final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    return listView();
  }

  ListView listView() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return StreamBuilder(
          stream: bloc.search,
          builder: (context, snapshot) {
            return listRow(items[index], bloc.curSearch());
          },
        );
      },
    );
  }

  Widget listRow(String text, String search) {
    return Container(
      child: Visibility(
        visible: text.contains(search),
        child: ListTile(
          title: Text(text),
        ),
      ),
    );
  }
}

// Testing purposes -- create a datasource of items
final items = List<String>.generate(10, (i) => "Item $i");