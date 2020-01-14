import 'package:equatable/equatable.dart';

abstract class TimelineEvent extends Equatable {
  const TimelineEvent();

  @override
  List<Object> get props => [];
}

class LoadTimeline extends TimelineEvent {
  final date;
  LoadTimeline(this.date);

  @override
  List<Object> get props => [date];
}