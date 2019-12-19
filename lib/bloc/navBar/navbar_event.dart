import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NavBarEvent extends Equatable {
  const NavBarEvent();

  @override
  List<Object> get props => [];
}

class TimerEvent extends NavBarEvent {}

class CalendarEvent extends NavBarEvent {}