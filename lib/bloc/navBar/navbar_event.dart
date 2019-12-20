import 'package:equatable/equatable.dart';

abstract class NavBarEvent extends Equatable {
  const NavBarEvent();

  @override
  List<Object> get props => [];
}

class TimerEvent extends NavBarEvent {}

class CalendarEvent extends NavBarEvent {}