import 'package:scheduler/data/models/dbModel.dart';

class TaskHistory extends DbModel{
  int taskID;
  DateTime startTime;
  DateTime endTime;
  int duration; //minutes
  bool completed;

  List<Object> get props => [id, taskID, startTime,endTime, duration, completed];

  static fromMap(Map<String,dynamic> map){
    return new TaskHistory(map["id"], map["taskID"], map["startTime"], map["endTime"], map["duration"], map["completed"]);
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

  TaskHistory(int id, int taskID, int startTime, int endTime, int duration, int completed):super(id){
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.endTime = new DateTime.fromMillisecondsSinceEpoch(endTime);
    this.duration = duration;
    this.completed = (completed == 1) ? true : false;
  }
  TaskHistory.fromDuration(int taskID, int startTime, int duration):super(null){
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.endTime = new DateTime.fromMillisecondsSinceEpoch(startTime + duration*60*1000);
    print(this.startTime.toString());
    print(this.endTime.toString());
    this.duration = duration;
    this.completed = false;
  }
  TaskHistory.fromEndTime(int taskID, int startTime, int endTime):super(null){
    this.taskID = taskID;
    this.startTime = new DateTime.fromMillisecondsSinceEpoch(startTime);
    this.endTime = new DateTime.fromMillisecondsSinceEpoch(endTime);
    this.duration = (endTime - startTime)~/1000;
    this.completed = false;
  }
}
