import 'package:equatable/equatable.dart';

abstract class NavbarState extends Equatable {
  final int index;
  const NavbarState(this.index);

  @override
  List<Object> get props => [index];
}

class Timer extends NavbarState{
  const Timer(int index) : super(index);

   @override
  String toString() => 'Timer { index: $index }';
}

class Calendar extends NavbarState{
  const Calendar(int index) : super(index);

   @override
  String toString() => 'Calendar { index: $index }';
}