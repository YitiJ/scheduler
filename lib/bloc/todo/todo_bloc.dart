import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models/todo.dart';
import 'package:scheduler/helper.dart';
import 'todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final DbManager dbManager;

  TodoBloc({@required this.dbManager});
  
  @override
  TodoState get initialState => TodoLoading();

  @override
  Stream<TodoState> mapEventToState(
    TodoEvent event,
  ) async* {
    if (event is LoadTodo) {
      yield* _mapLoadTodoToState(event);
    }
    else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    }
    else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    }
    else if (event is DeleteTodo){
      yield* _mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> _mapLoadTodoToState(LoadTodo event) async* {
    try {
      final todos = await this.dbManager.getTodosByDate(Helper.getStartDate(event.date), Helper.getEndDate(event.date));
      yield TodoLoaded(todos);
    } catch (_) {
      yield TaskNotLoaded();
    }
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {
    if (state is TodoLoaded) {
      Todo todo = event.todo;
      int dur = Helper.getTaskHisDuration(
        await dbManager.getTaskHistorysByTaskDate(Helper.getStartDate(todo.date), Helper.getEndDate(todo.date), todo.taskID));
      todo..completed = todo.duration <= dur;
      int id = await dbManager.insertTodo(todo);
      List<Todo> todos = (state as TodoLoaded).todo;
      if(Helper.getStartDate(event.date) == event.todo.date){
        todos = List.from((state as TodoLoaded).todo)..add(todo..id = id);
      }
      yield TodoLoaded(todos);
    }
  }

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {
    if (state is TodoLoaded) {
      List<Todo> updatedTodos = (state as TodoLoaded).todo;
      if(Helper.getStartDate(event.date) == event.updatedTodo.date){
        updatedTodos = (state as TodoLoaded).todo.map((todo) {
          return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
        }).toList();
      }
      else{
        updatedTodos = updatedTodos.where((todo) => todo.id != event.updatedTodo.id).toList();
      }
      yield TodoLoaded(updatedTodos);
      dbManager.updateTodo(event.updatedTodo);
    }
  }

  Stream<TodoState> _mapDeleteTodoToState(DeleteTodo event) async* {
    if (state is TodoLoaded) {
      final updatedTask = (state as TodoLoaded)
          .todo
          .where((todo) => todo.id != event.id)
          .toList();
      yield TodoLoaded(updatedTask);
      dbManager.deleteTodo(event.id);
    }
  }
}