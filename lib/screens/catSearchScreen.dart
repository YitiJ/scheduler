import 'package:flutter/material.dart';

import 'package:scheduler/customTemplates/export.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:scheduler/bloc/catSearch/catSearch.dart';

import 'package:scheduler/customTemplates/loadingIndicator.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';

class CatSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutTemplate.getPageWidget(content(), null),
    );
  }

  Widget content() {
    return _PageContent();
  }
}

class _PageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatBloc(dbManager: DbManager.instance)..add(LoadCat()),
      child: BlocBuilder<CatBloc, CatState>(
        builder: (context, state){
          List<Category> models = new List<Category>();
          Widget content;
          if(state is CatLoading){
            return LoadingIndicator();
          }
          else if (state is CatLoaded){
            state.cats.forEach(
                (category) => models.add(category)
              );
            content = DataSource(models);
          }
          else if (state is CatNotLoaded){
            content = Container(height: 0.00, width: 0.00,);
          }

          return Container(
            // padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: <Widget>[
                _headerNav(context),
                searchBar(),
                DataSource(),
              ],
            ),
          );
        }.
      ),
    );
  }
}

Widget _headerNav(BuildContext context) {
  return Stack(
    alignment: Alignment.center,
    children: [
      backBtn(() => Navigator.pop(context, null)),
      Center(
        child: Text(
          'Select Category',
          style: mainTheme.textTheme.body1,
        ),
      ),
    ],
  );
}

Widget searchBar() {
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
  DataSource({Key key, this.items}) : super (key: key);
  // NOTE: Testing purposes -- hardcoded data set
  // TODO: Replace with actual database data
  // final items = List<String>.generate(10, (i) => "Item $i");
  final List<Category> items;

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
            return index >= items.length ? AddNew(itemLen: items.length) : listRow(items[index], bloc, context);
          },
        );
      },
    );
  }

  Widget listRow(String text, Bloc bloc, BuildContext context) {
    return Visibility(
      visible: bloc.doesContain(text, bloc.curSearch()),
      child: ListTile(
        title: Text(text, style: mainTheme.textTheme.body1,),
        onTap: () => {
          Navigator.pop(context, text),
        },
      ),
    );
  }
}

class AddNew extends StatelessWidget {
  AddNew({Key key, this.itemLen}) : super(key: key);

  final int itemLen;

  @override
  Widget build(BuildContext context) {
      // return StreamBuilder(
      //   stream: bloc.search,
      //   builder: (context, snapshot) {
      //     return bloc.getHidden() ? addNewCat(bloc.curSearch()) : Container(height: 0, width: 0,);
      //   },
      // );
    return addNewCat(string)
  }

  Widget addNewCat(String string) {
    return FlatButton(
      child: Text(
        'Add new category "$string"',
        style: mainTheme.textTheme.body1,
      ),
      onPressed: () => { /* TODO: add string to database */ },
    );
  }
}