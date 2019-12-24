import 'package:flutter/material.dart';

import 'package:scheduler/data/models.dart';

import 'package:scheduler/customTemplates/export.dart';

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
          return todoItem(context, items[index], 'subtitle' , 'cat', TimeOfDay.now());
      },
    );
  }

  Widget todoItem(BuildContext context, String title, String subtitle, String cat, TimeOfDay time) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.white,
            //focusColor: Colors.white,
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
                  '${time.hour % 12}:${time.minute} ${time.hour <= 12 ? 'am' : 'pm'}',
                  style: mainTheme.textTheme.body1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),

      onTap: () => showAlertDialog(context, title, subtitle, cat, time),
    );
  }
}

showAlertDialog(BuildContext context, String title, String subtitle, String cat, TimeOfDay time) {
  Widget closeBtn = FlatButton(
    child: Text(
      "OK",
      style: mainTheme.textTheme.button.copyWith(color: purple)),
    onPressed: () => Navigator.of(context).pop(),
  );

  // set up the AlertDialog
  Widget alert() {
    return AlertDialog(
      title: Text(
        title,
        style: mainTheme.textTheme.subtitle.copyWith(color: purple),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15.0),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: purple[700],
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),

            child: Text(
              cat,
              style: mainTheme.textTheme.body1,
            ),
          ),
          Text(
            'NOTE: $subtitle',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          ),
          Padding(padding: EdgeInsets.all(5),),
          Text(
            'TIME: ${time.hour % 12}:${time.minute} ${time.hour <= 12 ? 'am' : 'pm'}',
            style: mainTheme.textTheme.body1.copyWith(color: purple),
          ),
        ],
      ),
      actions: [
        closeBtn,
      ],
    );
  }

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert();
    },
  );
}