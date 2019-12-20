import 'package:equatable/equatable.dart';

class Schedule extends Equatable{
  int id;
  int taskID;
  DateTime startTime;
  int duration; //minutes
  bool completed;

  get endTime {
    new DateTime.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch + duration*1000*60);
  }

  List<Object> get props => [id, taskID, startTime, duration];

  static fromMap(Map<String,dynamic> map){
    return new Schedule(map["id"], map["taskID"], map["startTime"], map["duration"], map["completed"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "taskID": taskID,
    "startTime":(startTime.millisecondsSinceEpoch).round(),
    "duration": duration,
    "completed": ((completed) ? 1 : 0)
    };
  }

  Schedule(int id, int taskID, int startTime, int duration, int completed){
    this.id = id;
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.duration = duration;
    this.completed = (completed == 1) ? true : false;
  }
  Schedule.newSchedule(int taskID, int startTime, int duration){
    this.id = null;
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.duration = duration;
    this.completed = false;
  }
}