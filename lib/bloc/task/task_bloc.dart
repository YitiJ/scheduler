import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models/task.dart';
import './task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
final DbManager dbManager;

  TaskBloc({@required this.dbManager});
  
  @override
  TaskState get initialState => TaskLoading();

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is LoadTask) {
      yield* _mapLoadTaskToState();
    }
    else if (event is AddTask) {
      yield* _mapAddTaskToState(event);
    }
    else if (event is UpdateTask) {
      yield* _mapUpdateTaskToState(event);
    }
    else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(event);
    } 
  }
  Stream<TaskState> _mapLoadTaskToState() async* {
    try {
      final tasks = await this.dbManager.getAllTask();
      yield TaskLoaded(tasks);
    } catch (_) {
      yield TaskNotLoaded();
    }
  }

  Stream<TaskState> _mapAddTaskToState(AddTask event) async* {
    if (state is TaskLoaded) {
      final List<Task> updatedTask = List.from((state as TaskLoaded).tasks)
        ..add(event.task);
      yield TaskLoaded(updatedTask);
      dbManager.insertTask(event.task);
    }
  }

  Stream<TaskState> _mapUpdateTaskToState(UpdateTask event) async* {
    if (state is TaskLoaded) {
      final List<Task> updatedTask = (state as TaskLoaded).tasks.map((task) {
        return task.id == event.updatedTask.id ? event.updatedTask : task;
      }).toList();
      yield TaskLoaded(updatedTask);
      dbManager.updateTask(event.updatedTask);
    }
  }

  Stream<TaskState> _mapDeleteTaskToState(DeleteTask event) async* {
    if (state is TaskLoaded) {
      final updatedTask = (state as TaskLoaded)
          .tasks
          .where((task) => task.id != event.task.id)
          .toList();
      yield TaskLoaded(updatedTask);
      dbManager.deleteTask(event.task.id);
    }
  }
}