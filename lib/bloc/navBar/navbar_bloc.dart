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
      yield* _mapPauseToState(event);
    }
  }
  @override
  Future<void> close() {
    return super.close();
  }

  Stream<NavBarState> _mapTimerToState(TimerEvent timer) async* {
    yield Timer(state.index);
  }

  Stream<NavBarState> _mapPauseToState(CalendarEvent pause) async* {
    yield Calendar(state.index);
  }
}
