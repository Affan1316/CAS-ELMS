import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_Usecase_fee.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_students_for_fee_use_case.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

class FeeAdminBloc extends Bloc<FeeAdminEvent, FeeAdminState> {
  final ReadGroupUsecaseFee _readGroupUsecaseFee = ReadGroupUsecaseFee();
  final ReadgroupstudentsforfeeUseCase _readgroupstudentsforfeeUseCase =
      ReadgroupstudentsforfeeUseCase();
  List<GroupEntity> _allGroups = [];
  final List<StudentFeatureGroupStudentEntityClass> _allStudentsOfThisGroup =
      [];

  FeeAdminBloc() : super(FeeAdminInitialState()) {
    on<FeeAdminFetchGroupsEvent>(_handleFetchGroups);
    on<FeeAdminGroupDataFilteringEvent>(_handleGroupDataFiltering);
    on<FeeAdminFetchGroupsStudentEvent>(_handleGroupStudentReading);
    on<FeeAdminGroupStudentsFilteringEvent>(_handleGroupStudentFiltering);
  }

  Future<void> _handleFetchGroups(
    FeeAdminFetchGroupsEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    // debugPrint('[FeeAdminBloc] _handleFetchGroups -> fetching groups');
    emit(FeeAdminGroupsLoadingState());

    try {
      // i use .first because i want get() like functionality
      // but in group feature data is being read from firestore as stream
      // for getting changed data instantly.
      // That is complex because then i have to use stream builder + Bloc builder.
      // And filter it .
      // So I decided to use .first, because we do not even need stream in admin side.

      final groups = await _readGroupUsecaseFee.getGroups().first;
      _allGroups = List<GroupEntity>.from(groups);

      // debugPrint(
      //   '[FeeAdminBloc] _handleFetchGroups -> fetched ${_allGroups.length} items',
      // );

      // if (_allGroups.length <= 10) {
      //   debugPrint('[FeeAdminBloc] fetched data: $_allGroups');
      // } else {
      //   debugPrint(
      //     '[FeeAdminBloc] fetched sample: ${_allGroups.take(5).toList()} ...',
      //   );
      // }

      emit(FeeAdminGroupsLoadedState(groups: _allGroups));
    } catch (e, st) {
      // debugPrint('[FeeAdminBloc] _handleFetchGroups ERROR -> $e');
      // debugPrint(st.toString());
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleGroupDataFiltering(
    FeeAdminGroupDataFilteringEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    try {
      // debugPrint(
      //   '[FeeAdminBloc] _handleGroupDataFiltering -> query="${event.query}", source length=${_allGroups.length}',
      // );

      final filtered = _filterGroups(event.query, _allGroups);

      // debugPrint(
      //   '[FeeAdminBloc] _handleGroupDataFiltering -> filtered length=${filtered.length}',
      // );

      // if (filtered.length <= 10) {
      //   debugPrint('[FeeAdminBloc] filtered data: $filtered');
      // } else {
      //   debugPrint(
      //     '[FeeAdminBloc] filtered sample: ${filtered.take(5).toList()} ...',
      //   );
      // }

      emit(FeeAdminGroupDataFilteringCompleteState(filteredDataList: filtered));
    } catch (e, st) {
      // debugPrint('[FeeAdminBloc] _handleGroupDataFiltering ERROR -> $e');
      // debugPrint(st.toString());
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  List<GroupEntity> _filterGroups(String query, List<GroupEntity> groups) {
    if (query.trim().isEmpty) {
      // debugPrint(
      //   '[FeeAdminBloc] _filterGroups -> query empty, returning full list (${groups.length})',
      // );
      return groups;
    }

    final q = query.toLowerCase();
    final result =
        groups.where((group) {
          final name = (group.groupName ?? '').toLowerCase();
          final code =
              group.groupName.isNotEmpty
                  ? group.groupName.substring(0, 1).toLowerCase()
                  : '';
          return name.contains(q) || code.contains(q);
        }).toList();

    // debugPrint(
    //   '[FeeAdminBloc] _filterGroups -> matched ${result.length} items for "$query"',
    // );
    return result;
  }

  Future<void> _handleGroupStudentReading(
    FeeAdminFetchGroupsStudentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(FeeAdminGroupsStudentsLoadingState());
    _allStudentsOfThisGroup.clear();
    var a = await _readgroupstudentsforfeeUseCase.read(event.groupTitle).first;
    var b = a.docs;
    var c;
    for (var element in b) {
      c = element.data();
      _allStudentsOfThisGroup.add(
        StudentFeatureGroupStudentEntityClass.fromMap(c),
      );
    }
    emit(FeeAdminGroupStudentsLoadedState(dataList: _allStudentsOfThisGroup));
  }

  Future<void> _handleGroupStudentFiltering(
    FeeAdminGroupStudentsFilteringEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    var filteredGroupGroupStudents = _filterGroupGroupStudents(
      event.query,
      _allStudentsOfThisGroup,
    );
    emit(
      FeeAdminGroupStudentsFilteringCompleteState(
        filteredDataList: filteredGroupGroupStudents,
      ),
    );
  }

  List<StudentFeatureGroupStudentEntityClass> _filterGroupGroupStudents(
    String query,
    List<StudentFeatureGroupStudentEntityClass> groupStudents,
  ) {
    if (query.trim().isEmpty) {
      // debugPrint(
      //   '[FeeAdminBloc] _filterGroups -> query empty, returning full list (${groups.length})',
      // );
      return groupStudents;
    }

    final q = query.toLowerCase();
    print("query is >>>>>>>>>> $query");
    print("list from which we are filtering is $groupStudents");
    final result =
        groupStudents.where((groupStudents) {
          final name = (groupStudents.name ?? '').toLowerCase();

          final code =
              groupStudents.rollNum.isNotEmpty
                  ? groupStudents.rollNum
                  : ''.toLowerCase();
          print("code is $code");
          return name.contains(q) || code.contains(q);
        }).toList();
    print("Filtred list is $result");
    // debugPrint(
    //   '[FeeAdminBloc] _filterGroups -> matched ${result.length} items for "$query"',
    // );
    return result;
  }
}
