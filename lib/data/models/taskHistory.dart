import 'package:scheduler/data/models/dbModel.dart';

class TaskHistory extends DbModel{
  int taskID;
  DateTime startTime;
  DateTime endTime;
  int get duration{
    return endTime.difference(startTime).inSeconds;
  }

  List<Object> get props => [id, taskID, startTime,endTime];

  static fromMap(Map<String,dynamic> map){
    return new TaskHistory(map["id"], map["taskID"],
      new DateTime.fromMillisecondsSinceEpoch(map["startTime"]),
      new DateTime.fromMillisecondsSinceEpoch(map["endTime"]));
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "taskID": taskID,
    "startTime": startTime.millisecondsSinceEpoch,
    "endTime": endTime.millisecondsSinceEpoch,
    };
  }

  TaskHistory(int id, this.taskID, this.startTime, this.endTime):super(id);

  TaskHistory.newTaskHistory(this.taskID, this.startTime, this.endTime):super(null);
}
