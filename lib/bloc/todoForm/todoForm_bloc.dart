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

  // Add data to stream
  Stream<Task> get task => _taskController.stream;

  // change data
  void addTask(final Task task) => _taskController.sink.add(task);
  
  // getters
  Task getTask() => _taskController.value;

  Task submit() {
    final validTask = _taskController.value;

    print('Title: $validTask');

    return validTask;
  }

  dispose() {
    _taskController.close();
  }
}