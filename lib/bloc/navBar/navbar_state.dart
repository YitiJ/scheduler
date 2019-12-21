import 'package:equatable/equatable.dart';

abstract class NavBarState extends Equatable {
  final int index;
  final DateTime date;

  const NavBarState(this.index, this.date);

  @override
  List<Object> get props => [index, date];
}

class Timer extends NavBarState{
  const Timer(int index) : super(index, null);

   @override
  String toString() => 'Timer { index: $index }';
}

class Calendar extends NavBarState{
  const Calendar(int index) : super(index, null);

   @override
  String toString() => 'Calendar { index: $index }';
}

class Schedule extends NavBarState{
  const Schedule(int index, DateTime date) : super(index, date);

   @override
  String toString() => 'Schedule { index: $index }';
}

class TaskList extends NavBarState{
  const TaskList(int index) : super(index, null);

   @override
  String toString() => 'TaskList { index: $index }';
}