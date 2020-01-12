import 'package:scheduler/data/dbManager.dart';

import 'data/models.dart';

class Helper{
  static DateTime getStartDate(DateTime time){
    return new DateTime(time.year, time.month, time.day);
  }

    static DateTime getEndDate(DateTime time){
    return new DateTime(time.year, time.month, time.day, 23,59,59);
  }

  static int getTaskHisDuration(List<TaskHistory> list){
    return list.fold(0, (int a, TaskHistory b) => a + b.duration);
  }

  static Future<int> getTaskDailyDuration(DateTime date) async{
    List<TaskHistory> his = await DbManager.instance.getTaskHistorysByDate(getStartDate(date), getEndDate(date));
    return getTaskHisDuration(his);
  }

  static Future<int> getTodoFinishTotal() async {
    List<Todo> todos = await DbManager.instance.getAllTodo();
    int completed = todos.fold(0, (int a, Todo b) => a + (b.completed ? 1 : 0));
    return completed;
  }

  static Future<double> getTodoFinishRate() async{
    List<Todo> todos = await DbManager.instance.getAllTodo();
    int completed = todos.fold(0, (int a, Todo b) => a + (b.completed ? 1 : 0));
    return completed/todos.length.toDouble();
  }
}