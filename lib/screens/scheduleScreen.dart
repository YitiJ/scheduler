import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget{

  ScheduleScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    Color color = Colors.white;
    return new ListView.builder(
      itemCount: 1,
      padding: EdgeInsets.only(left:20,top:75),
      itemBuilder: (context,index){
        return Row(
          children: <Widget> [Timeline(interval: 60)]);
      }
    );
  }
}

class Timeline extends StatelessWidget{
  int cells;
  double lineWidth;
  double lineHeight;
  double iconSize;
  Widget lineWidget;
  Widget circleWidget;
  Color color;
  int interval;
  Timeline({
    @required this.interval,
    this.iconSize = 15,
    this.lineWidth = 3,
    this.lineHeight = 50})
  :cells = (24*60/interval).toInt(),
  color = Colors.white,
  circleWidget = Container(
    margin: EdgeInsets.only(left: 10),
    width: iconSize,
    height: iconSize,
    decoration: new BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
        ),
  lineWidget = Container(
    margin: EdgeInsets.only(right: (iconSize-lineWidth)/2),
    width: lineWidth,
    height: lineHeight,
    decoration: new BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
    )
  );
  
  
  @override
  Widget build(BuildContext context){
    List<Widget> widgets = new List<Widget>();
    Widget timeWidget = Text("00:00 AM");
    int hour = 0;
    int minutes = 0;
    String time = 'AM';
    for(int i = 0; i < cells; i++){
      hour.toString().padLeft(2, '0');
      timeWidget = Text('${hour.toString().padLeft(2,'0')}:${minutes.toString().padLeft(2,'0')} $time');
      widgets.add(
        Row(children: <Widget> [timeWidget,circleWidget]));
      widgets.add(lineWidget);
      minutes += interval;
      if(hour == 12){
        hour = 0;
        time = 'PM';
      }
      if(minutes >= 60) {
        minutes -= 60;
        hour++;
      }
      
    }
    widgets.add(
      Row(children: <Widget> [Text('00:00 AM'),circleWidget]));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: widgets,
      );
  }
}

