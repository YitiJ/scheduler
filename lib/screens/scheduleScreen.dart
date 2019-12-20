import 'package:flutter/material.dart';
import 'package:scheduler/data/models.dart';

class ScheduleScreen extends StatelessWidget{

  ScheduleScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    Timeline timeline = new Timeline(interval: 60);
    return new ListView.builder(
      itemCount: 1,
      padding: EdgeInsets.only(left:20,top:75),
      itemBuilder: (context,index){
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [timeline,ScheduleList(timeline)]);
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


class ScheduleList extends StatelessWidget{
  Timeline timeline;
  int interval;
  double lineHeight;
  ScheduleList(this.timeline)
  :lineHeight = timeline.lineHeight,
    interval = timeline.interval;

  @override
  Widget build(BuildContext context){
    Schedule schedule = Schedule.newSchedule(0, DateTime.now().millisecondsSinceEpoch, 60);
    Task task = Task.newTask("homework",null);
    return Container(
      padding: EdgeInsets.only(top:timeline.iconSize/2,left: timeline.iconSize),
      child: Column(
        children:<Widget>[
          ScheduledTask(task,calculateHeightFromSecond(schedule.duration*60)),
          Container(margin: EdgeInsets.only(top:calculateHeightFromSecond(30*60))),
          ScheduledTask(task,calculateHeightFromSecond(schedule.duration*60)),
          Container(margin: EdgeInsets.only(top:calculateHeightFromSecond(120*60))),
          ScheduledTask(task,calculateHeightFromSecond(schedule.duration*60))]
      )
    );
  }

  double calculateHeightFromSecond(int duration){
    return duration*(lineHeight + timeline.iconSize)/(interval*60);
  }
}
class ScheduledTask extends StatelessWidget{
  //TODO: Make this look beautiful later
  Task task;
  double height;
  ScheduledTask(this.task,this.height);
  @override
  Widget build(BuildContext context){
    return Container(color: Colors.white, child: SizedBox(width: 225, height:  height));
  }
}
