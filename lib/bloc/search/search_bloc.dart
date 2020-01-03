import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:scheduler/data/dbManager.dart';

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

  final DbManager dbManager = DbManager.instance;

  final _searchController = BehaviorSubject<String>();

  // Add data to stream
  Stream<String> get search => _searchController.stream;
  
  // setters
  Function(String) get updateSearch {
    resetHidden();
    return _searchController.sink.add;
  }

  // getters
  String curSearch() => _searchController.value == null ? '' : _searchController.value;

  // other functions / variables
  bool _isHidden = true;

  void toggleHidden() => _isHidden = false;
  void resetHidden() => _isHidden = true;

  bool initState = true;   // number of elements in list

  bool getHidden() {
    return _isHidden; // returns true if all items are hidden
  }

  bool doesContain(Object s, String search, Function check) {
    if (search == '') resetHidden();

    if (check(s, search)) {
      toggleHidden();
      return true;
    } else {
      return false;
    }
  }

  Future<int> addNewCat(Object name) async {
    return await dbManager.insertCategory(name);
  }

  dispose() {
    _searchController.close();
  }
}