import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scheduler/data/dbManager.dart';
import 'package:scheduler/data/models.dart';
import 'package:scheduler/helper.dart';
import './timeline.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final DbManager dbManager;
  TimelineBloc({@required this.dbManager});
  @override
  TimelineState get initialState => TimelineLoading();

  @override
  Stream<TimelineState> mapEventToState(
    TimelineEvent event,
  ) async* {
    if(event is LoadTimeline){
      try{
        final List<TaskHistory> histories 
          = await dbManager.getTaskHistorysByDate(Helper.getStartDate(event.date), Helper.getEndDate(event.date));
        List<Task> tasks = await _getTasksFromHistory(histories);
        yield(TimelineLoaded(histories,tasks));
      }
      catch(_){
        yield(TimelineNotLoaded());
      }
    }
  }

  Future<List<Task>> _getTasksFromHistory(List<TaskHistory> history) async{
    List<Task> tasks = List<Task>();
    for(TaskHistory his in history){
      Task task = await dbManager.getTask(his.taskID);
      tasks.add(task);
    }
    return tasks;
  }
}
