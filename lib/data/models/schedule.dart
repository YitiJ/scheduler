import 'package:equatable/equatable.dart';

class Schedule extends Equatable{
  int id;
  int taskID;
  DateTime startTime;
  DateTime endTime;
  int duration; //minutes
  bool completed;

  List<Object> get props => [id, taskID, startTime,endTime, duration, completed];

  static fromMap(Map<String,dynamic> map){
    return new Schedule(map["id"], map["taskID"], map["startTime"], map["endTime"], map["duration"], map["completed"]);
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

  Schedule(int id, int taskID, int startTime, int endTime, int duration, int completed){
    this.id = id;
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.endTime = new DateTime.fromMillisecondsSinceEpoch(endTime);
    this.duration = duration;
    this.completed = (completed == 1) ? true : false;
  }
  Schedule.newScheduleDuration(int taskID, int startTime, int duration){
    this.id = null;
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.endTime = new DateTime.fromMillisecondsSinceEpoch(startTime + duration*60*1000);
    print(this.startTime.toString());
    print(this.endTime.toString());
    this.duration = duration;
    this.completed = false;
  }
  Schedule.newScheduleEndTime(int taskID, int startTime, int endTime){
    this.id = null;
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.endTime = new DateTime.fromMillisecondsSinceEpoch(endTime);
    this.duration = (endTime - startTime)~/1000;
    this.completed = false;
  }
}