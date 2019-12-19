import 'package:equatable/equatable.dart';

class Schedule extends Equatable{
  int id;
  int taskID;
  DateTime startTime;
  int duration;

  List<Object> get props => [id, taskID, startTime, duration];

  static fromMap(Map<String,dynamic> map){
    return new Schedule(map["id"], map["taskID"], map["startTime"], map["duration"]);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "taskID": taskID,
    "startTime":(startTime.millisecondsSinceEpoch/1000).round(),
    "duration": duration
    };
  }

  Schedule(int id, int taskID, int startTime, int duration){
    this.id = id;
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime*1000);
    this.duration = duration;
  }
  Schedule.newSchedule(int taskID, int startTime, int duration){
    Schedule(null, taskID,startTime,duration);
  }
}