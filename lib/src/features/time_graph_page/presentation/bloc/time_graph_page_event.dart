part of 'time_graph_page_bloc.dart';

@immutable
abstract class TimeGraphPageEvent {
  const TimeGraphPageEvent();
}

class ThisWeekEvent extends TimeGraphPageEvent {
  const ThisWeekEvent();
}

class LastWeekEvent extends TimeGraphPageEvent {
  const LastWeekEvent();
  
}

class ThisMonthEvent extends TimeGraphPageEvent {
  const ThisMonthEvent();
  
}
class SelectiveRangeEvent extends TimeGraphPageEvent {
  
  final DateTimeRange dateRange;
  const SelectiveRangeEvent(this.dateRange);
  
}
 
