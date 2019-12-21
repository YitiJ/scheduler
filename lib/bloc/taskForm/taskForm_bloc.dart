import 'dart:async';
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
  final _titleController = BehaviorSubject<String>();
  final _noteController = BehaviorSubject<String>();
  final _dateController = BehaviorSubject<DateTime>();
  final _passwordController = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get title => _titleController.stream.transform(validateTitle);
  Stream<String> get note => _noteController.stream.transform(validateText);
  Stream<DateTime> get date => _dateController.stream.transform(validateDate);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Observable.combineLatest2(title, Observable.fromIterable([note, date, password]), (e, p) => true);

  // change data
  Function(String) get changeTitle => _titleController.sink.add;
  Function(String) get changeNote => _noteController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  void addDate(final DateTime date) => _dateController.sink.add(date);

  DateTime newestDate() => _dateController.value;

  submit() {
    final validTitle = _titleController.value;
    final validNote = _noteController.value;
    final validDate = _dateController.value;
    final validPassword = _passwordController.value;

    print('Title: $validTitle, note: $validNote, date: $validDate, password: $validPassword');
  }

  dispose() {
    _titleController.close();
    _noteController.close();
    _dateController.close();
    _passwordController.close();
  }
}

//Note: This creates a global instance of Bloc that's automatically exported and can be accessed anywhere in the app