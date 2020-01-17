// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scheduler/bloc/timeline/timeline.dart';
import 'package:scheduler/customTemplates/loadingIndicator.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';

import 'package:scheduler/customTemplates/export.dart';

class TimelineScreen extends StatelessWidget{

  final DateTime date;
  TimelineScreen(this.date);

  @override
  Widget build(BuildContext context){
    final Timeline timeline = new Timeline(interval: 60);
    return BlocProvider<TimelineBloc>(
      create: (context) => TimelineBloc(dbManager: DbManager.instance)..add(LoadTimeline(date)),
      child: BlocBuilder<TimelineBloc,TimelineState>(
        builder: (context, state){
          if(state is TimelineLoading){
            return LoadingIndicator();
          }
          if(state is TimelineLoaded){
            return ListView.builder(
              itemCount: 1,
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 30.0),
              itemBuilder: (context,index){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    timeline,
                    Expanded(
                      child: ScheduleList(timeline,state.tasks,state.histories),
                    ),
                  ]
                );
              }
            );
          }
          if (state is TimelineNotLoaded){
            return Container();
          }
        },
      )
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
    this.iconSize = 10,
    this.lineWidth = 2,
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
  List<TaskHistory> scheduleList;
  List<Task> taskList;
  ScheduleList(this.timeline,this.taskList, this.scheduleList)
  :lineHeight = timeline.lineHeight,
    interval = timeline.interval;

  @override
  Widget build(BuildContext context){
    List<Widget> list = List<Widget>();
    if(scheduleList.length > 0){
      DateTime start = scheduleList[0].startTime;
      list.add(
          Container(
            margin: EdgeInsets.only(
              top: calculateHeightFromSecond(start.hour * 3600 + start.minute * 60)),
          )
      );
      list.add(ScheduledTask(taskList[0], scheduleList[0] ,calculateHeightFromSecond(scheduleList[0].duration)));
    }
    for(int i = 1; i < scheduleList.length; i++){
      DateTime lastStart = scheduleList[i-1].endTime;
      Duration dur = scheduleList[i].startTime.difference(lastStart);
      list.add(
          Container(
            margin: EdgeInsets.only(
              top: calculateHeightFromSecond(dur.inSeconds),)
          )
      );
      list.add(ScheduledTask(taskList[i], scheduleList[0] ,calculateHeightFromSecond(scheduleList[i].duration)));
    }
    
    return Container(
      padding: EdgeInsets.only(top:timeline.iconSize/2,left: timeline.iconSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: list
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
  TaskHistory history;
  double height;
  ScheduledTask(this.task,this.history,this.height);
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => {
        showAlertDialog(context, task, history),
      },

      child: Container(
        decoration: BoxDecoration(
          color: mainTheme.accentColor,
          borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
        ),

        child: SizedBox(
          width: 225,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              alignment: Alignment.topLeft,
              fit: BoxFit.none,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget> [
                  Text(
                    '${task.name[0].toUpperCase()}${task.name.substring(1)}',
                  ),

                  Text(
                    '${task.description}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, Task task, TaskHistory his) {
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
          task.name,
          style: mainTheme.textTheme.subtitle.copyWith(color: purple),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Tag(
              margin: EdgeInsets.only(bottom: 15.0),
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              bgColor: purple[700],
              child: FutureBuilder(
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData ? snapshot.data.name : 'None',
                    style: mainTheme.textTheme.body1,
                  );
                },
              ),
            ),
            Text(
              'NOTE: ${task.description}',
              style: mainTheme.textTheme.body1.copyWith(color: purple),
            ),
            Padding(padding: EdgeInsets.all(5),),
            Text(
              'DATE: ${DateFormat.yMMMd().format(history.startTime)}',
              style: mainTheme.textTheme.body1.copyWith(color: purple),
            ),
            Padding(padding: EdgeInsets.all(5),),
            Text(
              'TIME SPENT: ${(history.duration~/3600)}h ${(history.duration%3600)~/60}m ${history.duration%60}s',
              style: mainTheme.textTheme.body1.copyWith(color: purple),
            )
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

  Widget closeBtn = Builder(
    builder: (context) => FlatButton(
      child: Text(
        "OK",
        style: mainTheme.textTheme.button.copyWith(color: purple)),
      onPressed: () => Navigator.of(context).pop(),
    ),
  );
}
