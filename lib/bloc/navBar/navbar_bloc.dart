import 'package:rxdart/rxdart.dart';

enum Pages { timer, calendar, schedule, taskList, catSearch }

class BottomNavBarBloc {
  final _pageController = BehaviorSubject<Pages>();
  final _dateController = BehaviorSubject<DateTime>();

  Pages defaultPage = Pages.timer;
  DateTime defaultDate = DateTime.now();

  Stream<Pages> get page => _pageController.stream;    //.transform(validateDate);
  Stream<DateTime> get date => _dateController.stream;    //.transform(validateDate);

  // setters
  void switchPage(final Pages i) {
    _pageController.sink.add(i);
  }

  void addDate(final DateTime d) {
    _dateController.sink.add(d);
  }

  //getters
  Pages getPage() {return _pageController.value == null ? defaultPage : _pageController.value;}
  DateTime getDate() {return _dateController.value == null ? defaultDate : _dateController.value;}

  close() {
    _pageController.close();
    _dateController.close();
  }
}