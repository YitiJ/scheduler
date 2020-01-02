import 'package:flutter/material.dart';

import 'package:scheduler/customTemplates/export.dart';

import 'package:scheduler/bloc/catSearch/catSearch.dart';
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
    return Provider(
      child: _PageContent(cats: cats),
    );
  }
}

class _PageContent extends StatelessWidget {
  _PageContent({Key key, this.cats}) : super (key: key);

  final List<Category> cats;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          _headerNav(context),
          _searchBar(bloc),
          DataSource(items: cats, bloc: bloc),
        ],
      ),
    );
  }
}

Widget _headerNav(BuildContext context) {
  return Stack(
    alignment: Alignment.centerLeft,
    children: [
      backBtn(() => Navigator.pop(context, null)),
      Center(
        child: Text(
          'Select Category',
          style: mainTheme.textTheme.subtitle,
        ),
      ),
    ],
  );
}

Widget _searchBar(Bloc bloc) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: StreamBuilder(
      stream: bloc.search,
      builder: (context, snapshot) {
        return TextField(
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
  DataSource({Key key, this.items, @required this.bloc}) : super(key: key);

 final List<Category> items;
 final Bloc bloc;

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
            return index >= items.length ? AddNew(bloc: bloc) : listRow(items[index], bloc, context);
          },
        );
      },
    );
  }

  Widget listRow(Category cat, Bloc bloc, BuildContext context) {
    return Visibility(
      visible: bloc.doesContain(cat.name, bloc.curSearch()),
      child: ListTile(
        title: Text(cat.name, style: mainTheme.textTheme.body1,),
        onTap: () => {
          // print('${cat.name}, ${cat.id}'),
          Navigator.pop(context, cat),
        },
      ),
    );
  }
}

class AddNew extends StatelessWidget {
  AddNew({Key key, this.cats, this.bloc}) : super(key: key);

  final List<Category> cats;
  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.search,
      builder: (context, snapshot) {
        /* TODO: check for blank search and spaces only searches */
        /* TODO: display some alert / visual for no search results */
        return bloc.getHidden() && bloc.curSearch().length > 0 ? addNewCat(bloc.curSearch(), context) : Container(height: 0, width: 0,);
      },
    );
  }

  Widget addNewCat(String string, BuildContext context){
    return FlatButton(
      child: Text(
        'Add new category "$string"',
        style: mainTheme.textTheme.body1,
      ),
      onPressed: () async {
        final newCat = Category.newCategory(string);
        Category cat = new Category(await bloc.addNewCat(newCat), newCat.name);
        Navigator.of(context).pop(cat);
      },
    );
  }
}