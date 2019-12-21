import 'dart:async';
import 'package:flutter/material.dart';

import 'validators.dart';
import 'package:rxdart/rxdart.dart';

//* Using a shortcut getter method on the class to create simpler and friendlier API for the class to provide access of a particular function on StreamController
//* Mixin can only be used on a class that extends from a base class, therefore, we are adding Bloc class that extends from the Object class
//NOTE: Or you can write "class Bloc extends Validators" since we don't really need to extend Bloc from a base class
class Bloc extends Object with Validators {
  //* "_" sets the instance variable to a private variable
  //NOTE: By default, streams are created as "single-subscription stream", but in this case and in most cases, we need to create "broadcast stream"
  //Note(con'd): because the email/password streams are consumed by the email/password fields as well as the combineLastest2 RxDart method
  //Note:(con'd): because we need to merge these two streams as one and get the lastest streams of both that are valid to enable the button state
  //Note:(con'd): Thus, below two streams are being consumed multiple times

  //NOTE: We are leveraging the additional functionality from BehaviorSubject to go back in time and retrieve the lastest value of the streams for form submission
  //NOTE: Dart StreamController doesn't have such functionality

  final _expandableController = BehaviorSubject<bool>();
  final _titleController = BehaviorSubject<String>();
  final _noteController = BehaviorSubject<String>();
  final _dateController = BehaviorSubject<DateTime>();
  final _timeController = BehaviorSubject<TimeOfDay>();

  // Add data to stream
  Stream<bool> get isExpanded => _expandableController.stream;

  Stream<String> get title => _titleController.stream.transform(validateTitle);
  Stream<String> get note => _noteController.stream.transform(validateText);
  Stream<DateTime> get date => _dateController.stream;    //.transform(validateDate);
  Stream<TimeOfDay> get time => _timeController.stream;   //.transform(validateTime);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(title, Observable.fromIterable([note, date, time]), (e, p) => true);

  // change data
  Function(String) get changeTitle => _titleController.sink.add;
  Function(String) get changeNote => _noteController.sink.add;

  void toggleExpandable() => _expandableController.value == null || !_expandableController.value ? _expandableController.sink.add(true) : _expandableController.sink.add(false);

  void addDate(final DateTime date) => _dateController.sink.add(date);
  void addTime(final TimeOfDay time) => _timeController.sink.add(time);


  // getters
  String expandableHeaderText() => _expandableController.value == null || !_expandableController.value ? 'Add to Calendar' : 'Remove from Calendar';
  IconData expandableHeaderIcon() => _expandableController.value == null || !_expandableController.value ? Icons.arrow_drop_up : Icons.arrow_drop_down;
  
  bool expandedState() => _expandableController.value == null ? false : _expandableController.value;

  DateTime newestDate() => _dateController.value;
  TimeOfDay newestTime() => _timeController.value;

  submit() {
    final validTitle = _titleController.value;
    final validNote = _noteController.value;
    final validDate = _dateController.value;
    final validTime = _timeController.value;

    print('Title: $validTitle, note: $validNote, date: $validDate, time: $validTime');
  }

  dispose() {
    _expandableController.close();
    _titleController.close();
    _noteController.close();
    _dateController.close();
    _timeController.close();
  }
}

//Note: This creates a global instance of Bloc that's automatically exported and can be accessed anywhere in the app