import 'package:flutter/material.dart';
import 'package:scheduler/data/models.dart';

import 'package:intl/intl.dart';

class TimelineScreen extends StatelessWidget{
  TimelineScreen({Key key, this.date}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context){
    final Timeline timeline = new Timeline(interval: 60);
    return Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              DateFormat.yMMMMd().format(date),
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: 1,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context,index){
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [timeline,ScheduleList(timeline)]);
                }
              ),
            ),
          // ),
        ],
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
    Task task = Task.newTask("homework",null);
    List<TaskHistory> scheduleList = <TaskHistory>[
      TaskHistory.fromDuration(0, DateTime.now().millisecondsSinceEpoch - 360*1000*60, 60),
      TaskHistory.fromDuration(0, DateTime.now().millisecondsSinceEpoch - 180*1000*60, 30),
      TaskHistory.fromDuration(0, DateTime.now().millisecondsSinceEpoch - 60*1000*60, 60)];


    List<Task> taskList =<Task> [task, task, task];
    List<Widget> list = List<Widget>();
    if(scheduleList.length > 0){
      DateTime start = scheduleList[0].startTime;
      list.add(
          Container(margin: EdgeInsets.only(top: calculateHeightFromSecond(start.hour * 3600 +start.minute * 60)),)
      );
      list.add(ScheduledTask(taskList[0],calculateHeightFromSecond(scheduleList[0].duration*60)));
    }
    for(int i = 1; i < scheduleList.length; i++){
      DateTime lastStart = scheduleList[i-1].endTime;
      Duration dur = scheduleList[i].startTime.difference(lastStart);
      list.add(
          Container(
            margin: EdgeInsets.only(
              top: calculateHeightFromSecond(dur.inSeconds),))
      );
      list.add(ScheduledTask(taskList[i],calculateHeightFromSecond(scheduleList[i].duration*60)));
    }
    
    return Container(
      padding: EdgeInsets.only(top:timeline.iconSize/2,left: timeline.iconSize),
      child: Column(
        children:list
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
