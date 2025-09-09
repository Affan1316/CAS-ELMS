part of 'time_graph_page_bloc.dart';

@immutable
abstract class TimeGraphPageState {
  const TimeGraphPageState();
}

class TimeGraphPageInitial extends TimeGraphPageState {}

class TimeGraphPageLoading extends TimeGraphPageState {}

class TimeGraphPageLoaded extends TimeGraphPageState {
  final List<DailyStudyData> studentData;
  final String? selectiveFilter;
  final DateTimeRange? dateRange;
  final double? averageHours;
  final double? totalHours;
  

  const TimeGraphPageLoaded({
    required this.studentData,
    this.selectiveFilter,
    this.dateRange,this.averageHours,this.totalHours, 
  });
}

class TimeGraphPageError extends TimeGraphPageState {}
