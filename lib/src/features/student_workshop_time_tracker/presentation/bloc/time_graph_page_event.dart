part of 'time_graph_page_bloc.dart';

@immutable
abstract class TimeGraphPageEvent {
  const TimeGraphPageEvent();
}

class ThisWeekEvent extends TimeGraphPageEvent {
  final String? rollNo;
  const ThisWeekEvent({required this.rollNo});
}

class LastWeekEvent extends TimeGraphPageEvent {
  final String? rollNo;
  const LastWeekEvent({this.rollNo});
}

class ThisMonthEvent extends TimeGraphPageEvent {
  final String? rollNo;
  const ThisMonthEvent({required this.rollNo});
}

class SelectiveRangeEvent extends TimeGraphPageEvent {
  final DateTimeRange dateRange;
  final String? rollNo;
  const SelectiveRangeEvent({required this.dateRange, this.rollNo});
}

class InitStudentData extends TimeGraphPageEvent {
  const InitStudentData();
}
