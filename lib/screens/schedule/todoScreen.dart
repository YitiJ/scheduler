import 'package:flutter/material.dart';

import 'package:scheduler/data/models.dart';

import 'package:scheduler/customTemplates/export.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: listView(),
    );
  }

  ListView listView() {
    final items = List<String>.generate(10, (i) => "Item $i");
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 0.0),

      itemCount: items.length,
      itemBuilder: (context, index) {
          return todoItem(items[index], 'subtitle' , 'cat', TimeOfDay.now());
      },
    );
  }

  Widget todoItem(String title, String subtitle, String cat, TimeOfDay time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.white,
            focusColor: Colors.white,
            value: false,
          ),

          Padding(
            padding: EdgeInsets.only(left: 10.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    title,
                    style: mainTheme.textTheme.body1,
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  '${time.hour % 12}:${time.minute} ${time.hour > 12 ? 'am' : 'pm'}',
                  style: mainTheme.textTheme.body1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),

      onTap: () => {},
    );
  }
}