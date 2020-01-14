import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
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
      final tasks = await this.dbManager.getAllAvailTask();
      yield TaskLoaded(tasks);
    } catch (_) {
      yield TaskNotLoaded();
    }
  }

  Stream<TaskState> _mapAddTaskToState(AddTask event) async* {
    if (state is TaskLoaded) {
      int taskID = await dbManager.insertTask(event.task);
      int catID = event.category.id;
      final TaskCategoryRel rel = TaskCategoryRel.newRelation(taskID, catID);
      dbManager.insertTaskCategoryRel(rel);
      final List<Task> tasks = List.from((state as TaskLoaded).tasks)..add(event.task..id = taskID);
      yield TaskLoaded(tasks);
    }
  }

  Stream<TaskState> _mapUpdateTaskToState(UpdateTask event) async* {
    if (state is TaskLoaded) {
      final List<Task> updatedTask = (state as TaskLoaded).tasks.map((task) {
        return task.id == event.updatedTask.id ? event.updatedTask : task;
      }).toList();
      yield TaskLoaded(updatedTask);
      dbManager.updateTask(event.updatedTask);
      TaskCategoryRel rel = await dbManager.getTaskCategory(event.updatedTask.id);
      dbManager.updateTaskCategoryRel(rel..categoryID = event.updatedCategory.id);
    }
  }

  Stream<TaskState> _mapDeleteTaskToState(DeleteTask event) async* {
    if (state is TaskLoaded) {
      final updatedTask = (state as TaskLoaded)
          .tasks
          .where((task) => task.id != event.id)
          .toList();
      yield TaskLoaded(updatedTask);
      dbManager.deleteTask(event.id);
    }
  }
}