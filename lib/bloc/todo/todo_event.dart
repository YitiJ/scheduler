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
  final DateTime date;

  const AddTodo(this.todo,this.date);

  @override
  List<Object> get props => [todo,date];

  @override
  String toString() => 'Todo { Todo: $todo }';
}

class DeleteTodo extends TodoEvent {
  final int id;

  const DeleteTodo(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteTodo { DeleteTodo: $id }';
}