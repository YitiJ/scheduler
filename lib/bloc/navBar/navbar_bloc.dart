import 'dart:async';
import 'package:bloc/bloc.dart';
import 'navBar.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  final int _index = 0;
  
  @override
  NavBarState get initialState => Timer(_index);

  @override
  void onTransition(Transition<NavBarEvent, NavBarState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<NavBarState> mapEventToState(
    NavBarEvent event,
  ) async* {
     if (event is TimerEvent) {
      yield* _mapTimerToState(event);
    } else if (event is CalendarEvent) {
      yield* _mapCalendarToState(event);
    } else if (event is ScheduleEvent) {
      yield* _mapScheduleToState(event);
    } else if (event is TaskListEvent){
      yield* _mapTaskListToState(event);
    }
  }
  @override
  Future<void> close() {
    return super.close();
  }

  Stream<NavBarState> _mapTimerToState(TimerEvent timer) async* {
    yield Timer(0);
  }

  Stream<NavBarState> _mapCalendarToState(CalendarEvent calendar) async* {
    yield Calendar(1);
  }

  Stream<NavBarState> _mapScheduleToState(ScheduleEvent schedule) async* {
    yield Schedule(2, schedule.date);
  }

  Stream<NavBarState> _mapTaskListToState(TaskListEvent taskList) async* {
    yield TaskList(3);
  }
}
