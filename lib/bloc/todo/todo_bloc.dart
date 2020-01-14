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
      int todo = await dbManager.insertTodo(event.todo);

      final List<Todo> todos = List.from((state as TodoLoaded).todo)..add(event.todo..id = todo);
      yield TodoLoaded(todos);
    }
  }

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = (state as TodoLoaded).todo.map((todo) {
        return todo.id == event.updatedTodo.id ? event.updatedTodo : todo;
      }).toList();
      yield TodoLoaded(updatedTodos);
      dbManager.updateTodo(event.updatedTodo);
    }
  }
}