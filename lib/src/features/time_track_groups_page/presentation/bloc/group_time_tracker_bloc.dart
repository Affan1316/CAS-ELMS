import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/data/app_color.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/data/dummy_data.dart';
import 'package:meta/meta.dart';

part 'group_time_tracker_event.dart';
part 'group_time_tracker_state.dart';

class GroupTimeTrackerBloc
    extends Bloc<GroupTimeTrackerEvent, GroupTimeTrackerState> {
  GroupTimeTrackerBloc() : super(GroupTimeTrackerInitial()) {
    on<SelectCourseEvent>((event, emit) async {
      emit(GroupTimeTrackerLoading());
      await Future.delayed(Duration(seconds: 2));
      if (event.courseName == CourseNames.ai) {
        emit(GroupLoaded(groupNames: aiGroups, courseName: CourseNames.ai));
      } else if (event.courseName == CourseNames.android) {
        emit(
          GroupLoaded(
            groupNames: androidGroups,
            courseName: CourseNames.android,
          ),
        );
      } else if (event.courseName == CourseNames.flutter) {
        emit(
          GroupLoaded(
            groupNames: flutterGroups,
            courseName: CourseNames.flutter,
          ),
        );
      } else {
        emit(GroupTimeTrackerError());
      }
    });
  }
}
