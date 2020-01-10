import 'dart:async';
import 'package:scheduler/data/models.dart';

import 'package:rxdart/rxdart.dart';

//* Using a shortcut getter method on the class to create simpler and friendlier API for the class to provide access of a particular function on StreamController
//* Mixin can only be used on a class that extends from a base class, therefore, we are adding Bloc class that extends from the Object class
//NOTE: Or you can write "class Bloc extends Validators" since we don't really need to extend Bloc from a base class
class Bloc {
  //* "_" sets the instance variable to a private variable
  //NOTE: By default, streams are created as "single-subscription stream", but in this case and in most cases, we need to create "broadcast stream"
  //Note(con'd): because the email/password streams are consumed by the email/password fields as well as the combineLastest2 RxDart method
  //Note:(con'd): because we need to merge these two streams as one and get the lastest streams of both that are valid to enable the button state
  //Note:(con'd): Thus, below two streams are being consumed multiple times

  //NOTE: We are leveraging the additional functionality from BehaviorSubject to go back in time and retrieve the lastest value of the streams for form submission
  //NOTE: Dart StreamController doesn't have such functionality

  final _taskController = BehaviorSubject<Task>();
  final _dateController = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _durationController = BehaviorSubject<Duration>.seeded(Duration(seconds: 0));

  // Add data to stream
  Stream<Task> get task => _taskController.stream;
  Stream<DateTime> get date => _dateController.stream;
  Stream<Duration> get duration => _durationController.stream;

  // change data
  void addTask(final Task task) => _taskController.sink.add(task);
  void addDate(final DateTime date) => _dateController.sink.add(date);
  void addTime(final Duration dur) {print('add dur: $dur'); _durationController.sink.add(dur);}
  
  // getters
  Task getTask() => _taskController.value;
  DateTime getDate() => _dateController.value;
  Duration getDuration() => _durationController.value;

  Todo submit() {
    final validTask = _taskController.value;
    final validDate = _dateController.value;
    final validDuration = _durationController.value.inSeconds;

    print('Title: $validTask, date: $validDate, duration: $validDuration');

    if (validTask == null) return null;
    
    final Todo newTodo = Todo.newTodo(validTask.id, validDate, validDuration);

    return newTodo;
  }

  dispose() {
    _taskController.close();
    _dateController.close();
    _durationController.close();
  }
}