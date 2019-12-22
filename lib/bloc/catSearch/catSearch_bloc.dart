import 'dart:async';

import 'package:rxdart/rxdart.dart';

//* Using a shortcut getter method on the class to create simpler and friendlier API for the class to provide access of a particular function on StreamController
//* Mixin can only be used on a class that extends from a base class, therefore, we are adding Bloc class that extends from the Object class
//NOTE: Or you can write "class Bloc extends Validators" since we don't really need to extend Bloc from a base class
class Bloc extends Object {
  //* "_" sets the instance variable to a private variable
  //NOTE: By default, streams are created as "single-subscription stream", but in this case and in most cases, we need to create "broadcast stream"
  //Note(con'd): because the email/password streams are consumed by the email/password fields as well as the combineLastest2 RxDart method
  //Note:(con'd): because we need to merge these two streams as one and get the lastest streams of both that are valid to enable the button state
  //Note:(con'd): Thus, below two streams are being consumed multiple times

  //NOTE: We are leveraging the additional functionality from BehaviorSubject to go back in time and retrieve the lastest value of the streams for form submission
  //NOTE: Dart StreamController doesn't have such functionality

  final _searchController = BehaviorSubject<String>();
  final _visibleController = BehaviorSubject<bool>();

  // Add data to stream
  Stream<String> get search => _searchController.stream;
  Stream<bool> get count => _visibleController.stream;
  
  // setters
  Function(String) get updateSearch {
    resetCount();
    return _searchController.sink.add;
  }

  void toggle() => _visibleController.sink.add(!initState);
  void resetCount() => _visibleController.sink.add(initState);

  // getters
  String curSearch() => _searchController.value == null ? '' : _searchController.value;

  // other functions
  bool initState = true;   // number of elements in list

  bool getVisible() {
    print(_visibleController.value);
    return _visibleController.value; // returns number of visible items
  }

  bool doesContain(String s, String search) {
    if (search == '') resetCount();

    if (s.toLowerCase().contains(search.toLowerCase())) {
      toggle();
      print(getVisible());
      return true;
    } else {
      print(getVisible());
      return false;
    }
  }

  init() {
    resetCount();
  }

  dispose() {
    _searchController.close();
    _visibleController.close();
  }
}