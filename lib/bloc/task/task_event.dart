import 'package:equatable/equatable.dart';
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

  const AddTask(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'AddTask { task: $task }';
}

class UpdateTask extends TaskEvent {
  final Task updatedTask;

  const UpdateTask(this.updatedTask);

  @override
  List<Object> get props => [updatedTask];

  @override
  String toString() => 'UpdateTask { updatedTask: $updatedTask }';
}

class DeleteTask extends TaskEvent {
  final int id;

  const DeleteTask(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'DeleteTask { DeleteTask: $id }';
}