import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskLoading extends TaskState{}

class TaskLoaded extends TaskState{
  final List<Task> tasks;

  const TaskLoaded([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];

  @override
  String toString() => 'TaskLoaded { tasks: $tasks }';
}

class TaskNotLoaded extends TaskState{}