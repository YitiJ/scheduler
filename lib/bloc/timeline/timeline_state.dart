import 'package:equatable/equatable.dart';
import 'package:scheduler/data/models.dart';

abstract class TimelineState extends Equatable {
  const TimelineState();

  @override
  List<Object> get props => [];
}

class TimelineLoading extends TimelineState{}

class TimelineLoaded extends TimelineState{
  final List<TaskHistory> histories;
  final List<Task> tasks;

  const TimelineLoaded([this.histories = const [], this.tasks = const []]);

  @override
  List<Object> get props => [histories,tasks];

  @override
  String toString() => 'TimelineLoaded { taskHistory: $histories }';
}

class TimelineNotLoaded extends TimelineState{}