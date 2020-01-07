import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models/category.dart';
import 'package:scheduler/data/models/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
  @override
  List<Object> get props => [];
}

class LoadTodo extends TodoEvent{
}

class CheckBox extends TodoEvent {
  final Todo todo;

  const CheckBox(this.todo);

  @override
  List <Object> get props => [todo];

  @override
  String toString() => 'CheckBox { todo: $todo }';
}

class AddTodo extends TodoEvent {
  final Todo todo;

  const AddTodo(this.todo);

  @override
  List<Object> get props => [todo];

  @override
  String toString() => 'AddTask { Todo: $todo }';
}

class UpdateTodo extends TodoEvent {
  final Todo updatedTodo;

  const UpdateTodo(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];

  @override
  String toString() => 'UpdateTask { updatedTodo: $updatedTodo }';
}