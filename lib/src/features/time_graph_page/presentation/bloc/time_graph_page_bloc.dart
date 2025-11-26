import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Domain/repository/shared_preference_repository.dart';

import '../../../workshop_geofencing/Domain/repository/firestore_repository.dart';
import '../../data/dummy_data.dart';

part 'time_graph_page_event.dart';
part 'time_graph_page_state.dart';

class TimeGraphPageBloc extends Bloc<TimeGraphPageEvent, TimeGraphPageState> {
  String selectiveFilter = 'This Week';
  double totalHours = 0;
  double averageHours = 0;
  int maxHours = 8;
  FireStoreRepository fireStoreRepository = FireStoreRepository();
  SharePreferenceRepository sharePreferenceRepository =
      SharePreferenceRepository();

  TimeGraphPageBloc() : super(TimeGraphPageInitial()) {
    on<ThisWeekEvent>(onThisWeekEvent);
    on<LastWeekEvent>(onTLastWeekEvent);
    on<ThisMonthEvent>(onThisMonthEvent);
    on<SelectiveRangeEvent>(onSelectiveRangeEvent);
  }
  onThisWeekEvent(ThisWeekEvent event, Emitter<TimeGraphPageState> emit) async {
    emit(TimeGraphPageLoading());
    // await Future.delayed(Duration(seconds: 2));
    // TODO: add real data implementation
    var data = await fireStoreRepository.getDaysWorkshopTimeForThisWeek(
      studentId: await sharePreferenceRepository.getRollNo() ?? "",
    );
    selectiveFilter = 'This Week';
    if (data != null) {
      totalHours = data.fold(0.0, (sum, item) => sum + item.hours);
      averageHours = data.isNotEmpty ? totalHours / data.length : 0;
      emit(
        TimeGraphPageLoaded(
          studentData: data,
          selectiveFilter: selectiveFilter,
          dateRange: null,
        ),
      );
    } else {
      emit(TimeGraphPageErrorState(message: "No Data Found"));
    }
  }

  onTLastWeekEvent(
    LastWeekEvent event,
    Emitter<TimeGraphPageState> emit,
  ) async {
    emit(TimeGraphPageLoading());
    // await Future.delayed(Duration(seconds: 2));
    // TODO: add real data implementation
    var data = await fireStoreRepository.getDaysWorkshopTimeForLastWeek(
      studentId: await sharePreferenceRepository.getRollNo() ?? "",
    );
    selectiveFilter = 'Last Week';
    if (data != null) {
      totalHours = data.fold(0.0, (sum, item) => sum + item.hours);
      averageHours = data.isNotEmpty ? totalHours / data.length : 0;
      emit(
        TimeGraphPageLoaded(
          studentData: data,
          selectiveFilter: selectiveFilter,
          dateRange: null,
        ),
      );
    } else {
      emit(TimeGraphPageErrorState(message: "No Data Found"));
    }
  }

  onThisMonthEvent(
    ThisMonthEvent event,
    Emitter<TimeGraphPageState> emit,
  ) async {
    emit(TimeGraphPageLoading());
    await Future.delayed(Duration(seconds: 2));
    // TODO: add real data implementation
    var data = studyData['This Month']!.toList();
    selectiveFilter = 'This Month';
    totalHours = data.fold(0.0, (sum, item) => sum + item.hours);
    averageHours = data.isNotEmpty ? totalHours / data.length : 0;
    emit(
      TimeGraphPageLoaded(
        studentData: data,
        selectiveFilter: selectiveFilter,
        dateRange: null,
      ),
    );
  }

  onSelectiveRangeEvent(
    SelectiveRangeEvent event,
    Emitter<TimeGraphPageState> emit,
  ) async {
    emit(TimeGraphPageLoading());
    await Future.delayed(const Duration(seconds: 2));
    var data = await fireStoreRepository.getAllDaysWorkshopTime(
      studentId: "f18-01",
    );
    if (data != null) {
      var rangedData =
          data.where((data) {
            return data.date.isAfter(
                  event.dateRange.start.subtract(const Duration(days: 1)),
                ) &&
                data.date.isBefore(
                  event.dateRange!.end.add(const Duration(days: 1)),
                );
          }).toList();
      selectiveFilter = 'Custom';
      totalHours = data.fold(0.0, (sum, item) => sum + item.hours);
      averageHours = data.isNotEmpty ? totalHours / data.length : 0;
      emit(
        TimeGraphPageLoaded(
          studentData: rangedData,
          selectiveFilter: selectiveFilter,
          dateRange: event.dateRange,
        ),
      );
    } else {
      emit(TimeGraphPageErrorState(message: "No Data Found"));
    }
  }
}
