import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object> get props => [];
}

class LoadTodo extends TodoEvent{
  final List<Todo> lst;

  const LoadTodo(this.lst);
}

class CheckBox extends TodoEvent {
  final Todo todo;
  final bool newValue;

  const CheckBox(this.todo, this.newValue);

  @override
  List <Object> get props => [todo];

  @override
  String toString() => 'CheckBox { todo: $todo, newValue: $newValue }';
}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTask { Todo: $todo }';
}