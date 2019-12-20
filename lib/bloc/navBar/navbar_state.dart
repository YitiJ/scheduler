import 'package:equatable/equatable.dart';

abstract class NavBarState extends Equatable {
  final int index;
  const NavBarState(this.index);

  @override
  List<Object> get props => [index];
}

class Timer extends NavBarState{
  const Timer(int index) : super(index);

   @override
  String toString() => 'Timer { index: $index }';
}

class Calendar extends NavBarState{
  const Calendar(int index) : super(index);

   @override
  String toString() => 'Calendar { index: $index }';
}

class Schedule extends NavBarState{
  const Schedule(int index) : super(index);

   @override
  String toString() => 'Schedule { index: $index }';
}