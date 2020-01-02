import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models/category.dart';
import 'package:scheduler/data/models/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object> get props => [];
}

class LoadTask extends TaskEvent{

}

class AddTask extends TaskEvent {
  final Task task;
  final Category category;

  const AddTask(this.task,this.category);

  @override
  List<Object> get props => [task,category];

  @override
  String toString() => 'AddTask { task: $task , Category:$category}';
}

class UpdateTask extends TaskEvent {
  final Task updatedTask;
  final Category updatedCategory;

  const UpdateTask(this.updatedTask, this.updatedCategory);

  @override
  List<Object> get props => [updatedTask];

  @override
  String toString() => 'UpdateTask { updatedTask: $updatedTask, updatedCategory: $updatedCategory }';
}

class DeleteTask extends TaskEvent {
  final int id;

  const DeleteTask(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteTask { DeleteTask: $id }';
}