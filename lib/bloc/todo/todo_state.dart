import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoLoading extends TodoState{}

class TodoNotLoaded extends TodoState{}

class TodoLoaded extends TodoState{
  final List<Todo> todo;

  const TodoLoaded([this.todo = const []]);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'TaskLoaded { todo: $todo }';
}

class TaskNotLoaded extends TodoState{}