import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NavBarEvent extends Equatable {
  const NavBarEvent();

  @override
  List<Object> get props => [];
}

class TimerEvent extends NavBarEvent {}

class CalendarEvent extends NavBarEvent {}

class ScheduleEvent extends NavBarEvent {
  final DateTime date;

  const ScheduleEvent({@required this.date});

  @override
  String toString() => "Schedule { date: $date }";
}

class TaskListEvent extends NavBarEvent {}