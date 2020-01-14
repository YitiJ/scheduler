import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object> get props => [];
}

class LoadTodo extends TodoEvent{
  final DateTime date;
  const LoadTodo(this.date);
}

class UpdateTodo extends TodoEvent {
  final Todo updatedTodo;

  const UpdateTodo(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];

  @override
  String toString() => 'UpdatedTodo { Todo: $updatedTodo }';
}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'Todo { Todo: $todo }';
}