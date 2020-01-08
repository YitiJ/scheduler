import 'package:scheduler/data/models/dbModel.dart';

class Todo extends DbModel{
  int taskID;
  DateTime date;
  int duration; //minutes
  bool completed;

  List<Object> get props => [id, taskID, duration, completed];

  static fromMap(Map<String,dynamic> map){
    return new Todo(map["id"], map["taskID"],
      new DateTime.fromMillisecondsSinceEpoch(map["date"]),
      map["duration"], map["completed"] == 1 ? true : false);
  }

  Map<String, dynamic> toMap() {
    return {
    "id": id,
    "taskID": taskID,
    "date": new DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
    "duration": duration,
    "completed": completed ? 1 : 0,
    };
  }

  Todo(int id,this.taskID, this.date, this.duration, this.completed):super(id);
  Todo.newTodo(this.taskID, this.date, this.duration, {this.completed = false}):super(null);
}