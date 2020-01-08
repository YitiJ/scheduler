import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models/task.dart';
import 'package:scheduler/data/models/taskHistory.dart';
import 'timer.dart';
import 'ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _duration = 0;

  StreamSubscription<int> _tickerSubscription;
  Task _task;

  Task getTask() => _task;

  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        _ticker = ticker;
  
  @override
  TimerState get initialState => Ready(_duration);

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
     if (event is Start) {
      yield* _mapStartToState(event);
    } else if (event is Pause) {
      yield* _mapPauseToState(event);
    } else if (event is Resume) {
      yield* _mapResumeToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    } else if (event is Tick) {
      yield* _mapTickToState(event);
    } else if (event is TaskChange) {
      yield* _addTask(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapStartToState(Start start) async* {
    yield Running(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(Tick(duration: duration)));
  }

  Stream<TimerState> _mapPauseToState(Pause pause) async* {
    if (state is Running) {
      _tickerSubscription?.pause();
      yield Paused(state.duration);
    }
  }

  Stream<TimerState> _mapResumeToState(Resume pause) async* {
    if (state is Paused) {
      _tickerSubscription?.resume();
      yield Running(state.duration);
    }
  }

  Stream<TimerState> _mapResetToState(Reset reset) async* {
    DbManager db = DbManager.instance;
    _tickerSubscription?.cancel();
    DateTime endTime = DateTime.now();
    DateTime startTime = endTime.subtract(new Duration(seconds: state.duration));
    int diff = endTime.difference(startTime).inDays;
    if (_task == null){
      throw ErrorDescription("Task is not chosen!");
    }
    else if(diff == 0 && endTime.day == startTime.day){ //same day
      TaskHistory his = TaskHistory.newTaskHistory(_task.id, startTime, endTime);
      db.insertTaskHistory(his);
    }
    else{
      DateTime endTime1 = new DateTime(startTime.year, startTime.month, startTime.day,23,59,59);
      DateTime startTime1 = new DateTime(endTime.year, endTime.month, endTime.day);
      TaskHistory his1 = TaskHistory.newTaskHistory(_task.id, startTime, endTime1);
      TaskHistory his2 = TaskHistory.newTaskHistory(_task.id, startTime1, endTime);
      db.insertTaskHistory(his1);
      db.insertTaskHistory(his2);
    }
    yield Ready(_duration);

    /* TODO: Add time to db */
    /* duration: state.duration, category: _category */
  }

  Stream<TimerState> _mapTickToState(Tick tick) async* {
    yield tick.duration > 0 ? Running(tick.duration) : Finished(state.duration);
  }

  Stream<TimerState> _addTask(TaskChange taskEvent) async* {
    _task = taskEvent.task;
  }
}
