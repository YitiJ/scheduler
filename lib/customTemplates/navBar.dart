import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:scheduler/customTemplates/colours.dart';

import 'package:scheduler/bloc/navBar/navBar.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,

      child: Container(
        color: purple[200],
        padding: const EdgeInsets.only(top: 10, bottom: 15),
        
        child: NavRow(),
      ),
    );
  }
}

class NavRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      condition: (previousState, state) =>
          state.runtimeType != previousState.runtimeType,
      builder: (context, state) => _Actions(),
    );
  }
}

class _Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        navBarBloc: BlocProvider.of<NavBarBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({
    NavBarBloc navBarBloc,
  }) {
    final NavBarState currentState = navBarBloc.state;
    if (currentState is Timer) {
      return buttons( navBarBloc );
    }
    if (currentState is Calendar) {
      return buttons( navBarBloc );
    }
    return [];
  }
}

List<Widget> buttons( NavBarBloc navBarbloc ) {
  final NavBarBloc navBarBloc = navBarbloc;

  return [
      IconButton(
        icon: new Icon(Icons.timer, color: Colors.white,),
        onPressed: () => navBarBloc.add(TimerEvent()),
      ),
      IconButton(
        icon: new Icon(Icons.calendar_today, color: Colors.white,),
        onPressed: () => navBarBloc.add(CalendarEvent()),
      ),
      IconButton(
        icon: Icon(Icons.graphic_eq, color: Colors.white,),
        // onPressed: () => navBarBloc.add(),
      ),
      IconButton(
        icon: Icon(Icons.settings, color: Colors.white,),
        // onPressed: () => navBarBloc.add(),
      )
  ];
}
