import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:scheduler/customTemplates/colours.dart';

import 'package:scheduler/bloc/navBar/navbar_bloc.dart';

class NavBar extends StatelessWidget {
  NavBar({Key key, this.bloc}) : super (key: key);

  final BottomNavBarBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,

      child: Container(
        color: purple[200],
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        
        child: navRow(bloc),
      ),
    );
  }
}

Widget navRow(BottomNavBarBloc _bloc) {
  return StreamBuilder(
    stream: _bloc.page,
    builder: (context, snapshot) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons(_bloc),
      );
    },
  );
}

List<Widget> buttons(BottomNavBarBloc _bloc) {
  return [
      IconButton(
        highlightColor: purple,
        icon: new Icon(Icons.timer, color: Colors.white,),
        onPressed: () => _bloc.switchPage(Pages.timer),
      ),
      IconButton(
        highlightColor: purple,
        icon: new Icon(Icons.calendar_today, color: Colors.white,),
        onPressed: () => _bloc.switchPage(Pages.calendar),
      ),
      IconButton(
        highlightColor: purple,
        icon: new Icon(Icons.save_alt, color: Colors.white,),
        onPressed: () => _bloc.switchPage(Pages.taskList),
      ),
      IconButton(
        highlightColor: purple,
        icon: Icon(Icons.show_chart, color: Colors.white,),
        onPressed: () => _bloc.switchPage(Pages.newTask),
      ),
      IconButton(
        highlightColor: purple,
        icon: Icon(Icons.settings, color: Colors.white,),
        onPressed: () => {},
      )
  ];
}
