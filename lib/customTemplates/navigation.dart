import 'package:flutter/material.dart';
import 'package:scheduler/customTemplates/colours.dart';

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
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // currentIndex: index, // this will be set when a new tab is tapped
          // type: BottomNavigationBarType.fixed,
          children: [
            IconButton(
              icon: new Icon(Icons.timer, color: Colors.white,),
            ),
            IconButton(
              icon: new Icon(Icons.calendar_today, color: Colors.white,),
            ),
            IconButton(
              icon: Icon(Icons.graphic_eq, color: Colors.white,),
            ),
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white,),
            )
          ],
        ),
      ),
    );
  }
}