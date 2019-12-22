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
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Text(
            'Search Category',
            style: mainTheme.textTheme.body1,
          ),
          searchBar(bloc),
          DataSource(bloc: bloc),
        ],
      ),
    );
  }
}

Widget searchBar(Bloc bloc) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: StreamBuilder(
      stream: bloc.search,
      builder: (context, snapshot) {
        return TextField(
          // controller: editingController
          keyboardType: TextInputType.text,
          style: mainTheme.textTheme.body1,
          onChanged: bloc.updateSearch,
          
          decoration: searchFieldStyle('SEARCH'),
        );
      },
    ),
  );
}

class DataSource extends StatelessWidget {
  DataSource({Key key, @required this.bloc}) : super(key: key);

 final Bloc bloc;

  // NOTE: Testing purposes -- hardcoded data set
  final items = List<String>.generate(10, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: listView(),
    );
  }

  ListView listView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20.0),

      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        return StreamBuilder(
          stream: bloc.search,
          builder: (context, snapshot) {
            return index >= items.length ? AddNew(bloc: bloc) : listRow(items[index], bloc);
          },
        );
      },
    );
  }

  Widget listRow(String text, Bloc bloc) {
    return Visibility(
      visible: bloc.doesContain(text, bloc.curSearch()),
      child: ListTile(
        title: Text(text, style: mainTheme.textTheme.body1,),
      ),
    );
  }
}

class AddNew extends StatelessWidget {
  AddNew({Key key, this.bloc}) : super(key: key);

  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.search,
      builder: (context, snapshot) {
        return bloc.getHidden() ? addNewCat(bloc.curSearch()) : Container(height: 0, width: 0,);
      },
    );
  }

  Widget addNewCat(String string) {
    return FlatButton(
      child: Text(
        'Add new category "$string"',
        style: mainTheme.textTheme.body1,
      ),
      onPressed: () => {},
    );
  }
}