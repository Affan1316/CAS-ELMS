import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_Usecase_fee.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_students_for_fee_use_case.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_student_installment_usecase_fee.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/update_student_installment_usecase_fee.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/FeeAdminReadInstalmentUsecase.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/data_source/actual_implemetation_installment_repo.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

class FeeAdminBloc extends Bloc<FeeAdminEvent, FeeAdminState> {
  final ReadGroupUsecaseFee _readGroupUsecaseFee = ReadGroupUsecaseFee();
  final ReadgroupstudentsforfeeUseCase _readgroupstudentsforfeeUseCase =
      ReadgroupstudentsforfeeUseCase();
  final ActualImplemetationInstallmentRepo actualImplemetationInstallmentRepo =
      ActualImplemetationInstallmentRepo();
  final Feeadminreadinstalmentusecase feeadminreadinstalmentusecase =
      Feeadminreadinstalmentusecase();
  final UpdateStudentInstallmentUsecaseFee updateStudentInstallmentUsecaseFee =
      UpdateStudentInstallmentUsecaseFee();
  List<GroupEntity> _allGroups = [];
  final List<StudentFeatureGroupStudentEntityClass> _allStudentsOfThisGroup =
      [];

  FeeAdminBloc() : super(FeeAdminInitialState()) {
    on<FeeAdminFetchGroupsEvent>(_handleFetchGroups);
    on<FeeAdminGroupDataFilteringEvent>(_handleGroupDataFiltering);
    on<FeeAdminFetchGroupsStudentEvent>(_handleGroupStudentReading);
    on<FeeAdminGroupStudentsFilteringEvent>(_handleGroupStudentFiltering);
    on<InstallmentPageCalculateInst>(_onCalculateInstallment);
    on<CreateStudentInstallmentEvent>(_onCreateStudentInstallment);
    on<GetStudentInstalmentEvent>(_onGetStudent);
    on<UpdateStudentInstalmentEvent>(_handleUpdatingStudentInstalment);
    on<FetchFeesByDateRange>(_onFetchFeesByDateRange);
    on<FetchTodayFees>(_onFetchTodayFees);
    on<UpdateSelectedDate>(_onUpdateSelectedDate);
    on<SortFees>(_onSortFees);
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
    debugPrint("@@@@@@@_handleGroupStudentReading called@@@@@@@@@@@@@");
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

  // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  /// ✅ Handle fee calculation
  void _onCalculateInstallment(
    InstallmentPageCalculateInst event,
    Emitter<FeeAdminState> emit,
  ) {
    final totalFee = double.tryParse(event.totalFee);
    final installments = int.tryParse(event.installments);

    if (totalFee != null && installments != null && installments > 0) {
      final installmentAmount = totalFee / installments;
      emit(
        InstallmentPageInstallmentCalculatedState(
          installment: installmentAmount,
        ),
      );
    } else {
      emit(InstallmentPageInstallmentCalculatedState(installment: 0));
    }
  }

  /// ✅ Create a student with installments
  Future<void> _onCreateStudentInstallment(
    CreateStudentInstallmentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(InstallmentCreatingState());

    try {
      await actualImplemetationInstallmentRepo.createStudentWithInstallments(
        studentId: event.studentId,
        name: event.name,
        groupId: event.groupId,
        totalFee: event.totalFee,
        paidAmount: event.paidAmount,
        numberOfInstallments: event.numberOfInstallments,
      );

      emit(InstallmentCreatedSuccessState());
    } catch (e) {
      emit(InstallmentCreatedFailureState(error: e.toString()));
    }
  }

  /// ✅ Fetch a student from Firestore
  Future<void> _onGetStudent(
    GetStudentInstalmentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint(
      "<<<<<<<<Inside Block and intiating StudentLoadingState>>>>>>>>>> ",
    );
    emit(StudentInstalmentLoadingState());

    try {
      debugPrint("student id which reult in no document ${event.studentId}");
      final student = await feeadminreadinstalmentusecase.getStudent(
        event.studentId,
      );

      if (student != null) {
        emit(StudentLoadedState(student));
      } else {
        emit(StudentLoadFailureState("Student not found"));
      }
    } catch (e) {
      emit(StudentLoadFailureState(e.toString()));
    }
  }

  Future<void> _handleUpdatingStudentInstalment(
    UpdateStudentInstalmentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(UpdateStudentInstalmentLoadingState());
    var a = await updateStudentInstallmentUsecaseFee.update(
      installmentId: event.installmentId,
      paidAmount: event.paidAmount,
      paidDate: event.paidDate,
      paymentMethod: event.paymentMethod,
      studentId: event.studentId,
    );
    emit(UpdatedStudentInstalmentState());
  }

  Future<void> _onFetchFeesByDateRange(
    FetchFeesByDateRange event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(FeeHistoryLoading());
    try {
      final fees = await actualImplemetationInstallmentRepo
          .fetchFeesByDateRange(event.startDate, event.endDate);
      emit(
        FeeHistoryLoaded(
          fees: fees,
          startDate: event.startDate,
          endDate: event.endDate,
          sortOption: SortOptionEnum.dateDesc,
        ),
      );
    } catch (e) {
      emit(FeeHistoryError(e.toString()));
    }
  }

  Future<void> _onFetchTodayFees(
    FetchTodayFees event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(FeeHistoryLoading());
    try {
      final fees = await actualImplemetationInstallmentRepo.fetchTodayFees();
      emit(
        FeeHistoryLoaded(
          fees: fees,
          startDate: null,
          endDate: null,
          sortOption: SortOptionEnum.dateDesc,
        ),
      );
    } catch (e) {
      emit(FeeHistoryError(e.toString()));
    }
  }

  void _onUpdateSelectedDate(
    UpdateSelectedDate event,
    Emitter<FeeAdminState> emit,
  ) {
    if (state is FeeHistoryLoaded) {
      final s = state as FeeHistoryLoaded;
      emit(s.copyWith(startDate: event.startDate, endDate: event.endDate));
    } else {
      emit(
        FeeHistoryLoaded(
          fees: [],
          startDate: event.startDate,
          endDate: event.endDate,
          sortOption: SortOptionEnum.dateDesc,
        ),
      );
    }
  }

  void _onSortFees(SortFees event, Emitter<FeeAdminState> emit) {
    if (state is FeeHistoryLoaded) {
      final s = state as FeeHistoryLoaded;
      final newList = List<FeeEntityClass>.from(s.fees);
      switch (event.option) {
        case SortOptionEnum.dateDesc:
          newList.sort((a, b) => b.date.compareTo(a.date));
          break;
        case SortOptionEnum.dateAsc:
          newList.sort((a, b) => a.date.compareTo(b.date));
          break;
        case SortOptionEnum.amountDesc:
          newList.sort((a, b) => b.paidAmount.compareTo(a.paidAmount));
          break;
        case SortOptionEnum.amountAsc:
          newList.sort((a, b) => a.paidAmount.compareTo(b.paidAmount));
          break;
      }
      emit(s.copyWith(fees: newList, sortOption: event.option));
    }
  }
}
