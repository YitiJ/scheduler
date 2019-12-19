import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

class Timer extends NavbarEvent {}

class Calendar extends NavbarEvent {}