import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models/task.dart';
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
      yield* _mapLoadTodoToState();
    }
    else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    }
    else if (event is CheckBox) {
      yield* _mapCheckBoxToState(event);
    } 
  }

  Stream<TodoState> _mapLoadTodoToState() async* {
    try {
      final todo = await this.dbManager.getAllTodo();
      yield TodoLoaded(todo);
    } catch (_) {
      yield TodoNotLoaded();
    }
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {
    if (state is TodoLoaded) {
      int todo = await dbManager.insertTodo(event.todo);
      dbManager.insertTodo(todo);

      final List<Todo> todos = List.from((state as TodoLoaded).todo)..add(event.todo..id = todo);
      yield TodoLoaded(todos);
    }
  }

  Stream<TodoState> _mapCheckBoxToState(CheckBox event) async* {
    if (state is TodoLoaded) {
      final todo = (state as TodoLoaded).todo;
      todo.checked = !todo.checked;
      dbManager.updateTodo(todo);

      yield TodoLoaded(todo);
    }
  }
}