import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulter_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulters_collective.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/add_to_fee_defaulter_usecase.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/add_to_pending_fee2.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/add_to_super_admin_approval_list_usecase.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/defaulter_check_usecase.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_fee_defaulter_collective.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_fee_defaulter_usecase.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_Usecase_fee.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_names_fee_defaulters_usecase.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/read_group_students_for_fee_use_case.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/remove_student_from_defaulters_usecase.dart';
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

  final AddToFeeDefaulterUsecase addToFeeDefaulterUsecase =
      AddToFeeDefaulterUsecase();
  final ReadFeeDefaulterCollective readFeeDefaulterCollective =
      ReadFeeDefaulterCollective();
  final ReadFeeDefaulterUsecase readFeeDefaulterUsecase =
      ReadFeeDefaulterUsecase();
  final ReadGroupNamesFeeDefaultersUsecase readGroupNamesFeeDefaultersUsecase =
      ReadGroupNamesFeeDefaultersUsecase();
  final RemoveStudentFromDefaultersUsecase _removeStudentFromDefaultersUsecase =
      RemoveStudentFromDefaultersUsecase();
  final DefaulterCheckUsecase _defaulterCheckUsecase = DefaulterCheckUsecase();
  AddToSuperAdminApprovalListUsecase addToSuperAdminApprovalListUsecase =
      AddToSuperAdminApprovalListUsecase();
  AddToPendingFee2 addToPendingFee2 = AddToPendingFee2();

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

    on<FetchFeesByDateRange>(_onFetchFeesByDateRange);

    on<FetchTodayFees>(_onFetchTodayFees);

    on<UpdateSelectedDate>(_onUpdateSelectedDate);
    on<SortFees>(_onSortFees);
    on<AddFeeDefaulterEvent>(_handleAddingFeeDefaulter);
    on<ReadFeeDefaulterEvent>(_handleReadingFeeDefaulter);
    on<ReadFeeDefaulterGroupsEvent>(_handleReadingGroupNames);
    on<RemoveStudentFromDefaultersEvent>(_handleRemovingStudentFromDefaulters);
    on<CheckFeeDefaulterEvent>(_handleCheckingFeeDefaulter);
    on<AddToSuperAdminApprovalListEvent>(
      _handleAddingFeeInstallmentToSuperAdminApprovalList,
    );
    on<AddToPendingFee2Event>(_handleAddingToPendingFee);
  }

  Future<void> _handleFetchGroups(
    FeeAdminFetchGroupsEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(FeeAdminGroupsLoadingState());

    try {
      final groups = await _readGroupUsecaseFee.getGroups().first;
      _allGroups = List<GroupEntity>.from(groups);

      emit(FeeAdminGroupsLoadedState(groups: _allGroups));
    } catch (e, st) {
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleGroupDataFiltering(
    FeeAdminGroupDataFilteringEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    try {
      final filtered = _filterGroups(event.query, _allGroups);

      emit(FeeAdminGroupDataFilteringCompleteState(filteredDataList: filtered));
    } catch (e, st) {
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  List<GroupEntity> _filterGroups(String query, List<GroupEntity> groups) {
    if (query.trim().isEmpty) {
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

    return result;
  }

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

  Future<void> _onFetchFeesByDateRange(
    FetchFeesByDateRange event,
    Emitter<FeeAdminState> emit,
  ) async {
    emit(FeeHistoryLoading());
    try {
      final fees = await actualImplemetationInstallmentRepo
          .fetchFeesByDateRange(event.startDate, event.endDate);

      double cashPaymentTotal = 0;
      double JazzCashTotal = 0;
      double UBLTotal = 0;
      double easyPaisaTotal = 0;
      for (var fee in fees) {
        switch (fee.paymentMethod.name) {
          case "cashPayment":
            cashPaymentTotal = fee.paidAmount + cashPaymentTotal;
            break;
          case "jazzCash":
            JazzCashTotal = fee.paidAmount + JazzCashTotal;
            break;
          case "ubl":
            UBLTotal = fee.paidAmount + UBLTotal;
            break;
          case "easyPaisa":
            easyPaisaTotal = fee.paidAmount + easyPaisaTotal;
          default:
            throw AssertionError(
              "payment method invalid :${fee.paymentMethod.name}",
            );
        }
      }

      emit(
        FeeHistoryLoaded(
          fees: fees,
          startDate: event.startDate,
          endDate: event.endDate,
          sortOption: SortOptionEnum.dateDesc,
          JazzCashTotal: JazzCashTotal,
          UBLTotal: UBLTotal,
          cashPaymentTotal: cashPaymentTotal,
          easyPaisaTotal: easyPaisaTotal,
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
      double cashPaymentTotal = 0;
      double JazzCashTotal = 0;
      double UBLTotal = 0;
      double easyPaisaTotal = 0;
      for (var fee in fees) {
        switch (fee.paymentMethod.name) {
          case "cashPayment":
            cashPaymentTotal = fee.paidAmount + cashPaymentTotal;
            break;
          case "jazzCash":
            JazzCashTotal = fee.paidAmount + JazzCashTotal;
            break;
          case "ubl":
            UBLTotal = fee.paidAmount + UBLTotal;
            break;
          case "easyPaisa":
            easyPaisaTotal = fee.paidAmount + easyPaisaTotal;
          default:
            throw AssertionError(
              "payment method invalid :${fee.paymentMethod.name}",
            );
        }
      }
      debugPrint("###########################################");
      debugPrint("easyPaisaTotal:$easyPaisaTotal");
      debugPrint("JazzCashTotal:$JazzCashTotal");
      debugPrint("UBLTotal:$UBLTotal");
      debugPrint("cashPaymentTotal:$cashPaymentTotal");
      debugPrint("###########################################");
      emit(
        FeeHistoryLoaded(
          fees: fees,
          startDate: null,
          endDate: null,
          sortOption: SortOptionEnum.dateDesc,
          JazzCashTotal: JazzCashTotal,
          UBLTotal: UBLTotal,
          cashPaymentTotal: cashPaymentTotal,
          easyPaisaTotal: easyPaisaTotal,
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
          JazzCashTotal: 990,
          UBLTotal: 990,
          cashPaymentTotal: 990,
          easyPaisaTotal: 990,
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

  Future<void> _handleAddingFeeDefaulter(
    AddFeeDefaulterEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    await addToFeeDefaulterUsecase.add(
      event.studentId,
      event.name,
      event.rollnum,
      event.remaingFee,
      event.group,
    );
    emit(AddingFeeDefaulterCompleteState());
  }

  Future<void> _handleReadingFeeDefaulter(
    ReadFeeDefaulterEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("${event.groupId}");
    try {
      FeeDefaultersCollective feeDefaultersCollective =
          await readFeeDefaulterCollective.read(event.groupId);
      List<FeeDefaulterEntity> listOffeeDefaulterEntity =
          await readFeeDefaulterUsecase.read(event.groupId);
      emit(
        FeeDefaultersDataLoaded(
          listOFFeeDefaulterEntity: listOffeeDefaulterEntity,
          feeDefaultersCollective: feeDefaultersCollective,
          emittedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      emit(FeeAdminErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> _handleReadingGroupNames(
    ReadFeeDefaulterGroupsEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    List<String> listOfGroupNames =
        await readGroupNamesFeeDefaultersUsecase.get();
    emit(GroupNamesReadCompleted(listOFGroupNames: listOfGroupNames));
  }

  Future<void> _handleRemovingStudentFromDefaulters(
    RemoveStudentFromDefaultersEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    await _removeStudentFromDefaultersUsecase.remove(
      event.groupId,
      event.studentId,
      event.paidAmount,
      event.totalReaminingFeeForThisStudent,
    );
  }

  Future<void> _handleCheckingFeeDefaulter(
    CheckFeeDefaulterEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    bool? isDefaulter = await _defaulterCheckUsecase.check(
      event.groupId,
      event.studentId,
    );
    if (isDefaulter == null) {
      throw AssertionError("is defualter is null");
    }
    emit(CheckingingFeeDefaulterCompleteState(isDefaulter: isDefaulter));
  }

  Future<void> _handleAddingFeeInstallmentToSuperAdminApprovalList(
    AddToSuperAdminApprovalListEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    await addToSuperAdminApprovalListUsecase.add(event.student, event.index);
  }

  Future<void> _handleAddingToPendingFee(
    AddToPendingFee2Event event,
    Emitter<FeeAdminState> emit,
  ) async {
    await addToPendingFee2.add(
      event.student,
      event.instalment,
      event.paidAmount,
      event.paymentMethod,
    );
    final StudentFeeFeatureEntityClass? student =
        await feeadminreadinstalmentusecase.getStudent(event.student.id);

    emit(AddedToPendingFee(student: student!));
  }
}
