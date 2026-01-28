import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulter_entity.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_defaulters_collective.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/enums/sort_option_enum.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/usecases/ReadDayWiseFeesUsecase%20.dart';
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
  // ========================================
  // USE CASES
  // ========================================
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
  final ReadDayWiseFeesUsecase _readDayWiseFeesUsecase =
      ReadDayWiseFeesUsecase();

  // ========================================
  // STATE VARIABLES
  // ========================================
  List<GroupEntity> _allGroups = [];
  final List<StudentFeatureGroupStudentEntityClass> _allStudentsOfThisGroup =
      [];

  // ========================================
  // CONSTRUCTOR
  // ========================================
  FeeAdminBloc() : super(FeeAdminInitialState()) {
    debugPrint("========================================");
    debugPrint("FeeAdminBloc: Initializing...");
    debugPrint("========================================");

    // Group & Student Management
    on<FeeAdminFetchGroupsEvent>(_handleFetchGroups);
    on<FeeAdminGroupDataFilteringEvent>(_handleGroupDataFiltering);
    on<FeeAdminFetchGroupsStudentEvent>(_handleGroupStudentReading);
    on<FeeAdminGroupStudentsFilteringEvent>(_handleGroupStudentFiltering);

    // Installment Management
    on<InstallmentPageCalculateInst>(_onCalculateInstallment);
    on<CreateStudentInstallmentEvent>(_onCreateStudentInstallment);
    on<GetStudentInstalmentEvent>(_onGetStudent);

    // Fee History Management
    on<FetchFeesByDateRange>(_onFetchFeesByDateRange);
    on<FetchTodayFees>(_onFetchTodayFees);
    on<FetchDayWiseFees>(_onFetchDayWiseFees); // NEW

    // Fee History Actions
    on<UpdateSelectedDate>(_onUpdateSelectedDate);
    on<SortFees>(_onSortFees);

    // Defaulter Management
    on<AddFeeDefaulterEvent>(_handleAddingFeeDefaulter);
    on<ReadFeeDefaulterEvent>(_handleReadingFeeDefaulter);
    on<ReadFeeDefaulterGroupsEvent>(_handleReadingGroupNames);
    on<RemoveStudentFromDefaultersEvent>(_handleRemovingStudentFromDefaulters);
    on<CheckFeeDefaulterEvent>(_handleCheckingFeeDefaulter);

    // Approval & Pending Fee Management
    on<AddToSuperAdminApprovalListEvent>(
      _handleAddingFeeInstallmentToSuperAdminApprovalList,
    );
    on<AddToPendingFee2Event>(_handleAddingToPendingFee);

    debugPrint("FeeAdminBloc: Initialization complete");
  }

  // ========================================
  // GROUP MANAGEMENT HANDLERS
  // ========================================
  Future<void> _handleFetchGroups(
    FeeAdminFetchGroupsEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleFetchGroups: START");
    debugPrint("========================================");

    emit(FeeAdminGroupsLoadingState());

    try {
      final groups = await _readGroupUsecaseFee.getGroups().first;
      _allGroups = List<GroupEntity>.from(groups);

      debugPrint("_handleFetchGroups: Fetched ${_allGroups.length} groups");
      emit(FeeAdminGroupsLoadedState(groups: _allGroups));
    } catch (e) {
      debugPrint("❌ ERROR in _handleFetchGroups: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleGroupDataFiltering(
    FeeAdminGroupDataFilteringEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleGroupDataFiltering: Query = '${event.query}'");
    debugPrint("========================================");

    try {
      final filtered = _filterGroups(event.query, _allGroups);
      debugPrint(
        "_handleGroupDataFiltering: Filtered to ${filtered.length} groups",
      );

      emit(FeeAdminGroupDataFilteringCompleteState(filteredDataList: filtered));
    } catch (e) {
      debugPrint("❌ ERROR in _handleGroupDataFiltering: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  List<GroupEntity> _filterGroups(String query, List<GroupEntity> groups) {
    if (query.trim().isEmpty) {
      debugPrint("_filterGroups: Empty query, returning all groups");
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

    debugPrint("_filterGroups: Query '$q' matched ${result.length} groups");
    return result;
  }

  // ========================================
  // STUDENT MANAGEMENT HANDLERS
  // ========================================
  Future<void> _handleGroupStudentReading(
    FeeAdminFetchGroupsStudentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleGroupStudentReading: Group = '${event.groupTitle}'");
    debugPrint("========================================");

    emit(FeeAdminGroupsStudentsLoadingState());
    _allStudentsOfThisGroup.clear();

    try {
      var a =
          await _readgroupstudentsforfeeUseCase.read(event.groupTitle).first;
      var b = a.docs;
      Map<String, dynamic> c;

      for (var element in b) {
        c = element.data();
        _allStudentsOfThisGroup.add(
          StudentFeatureGroupStudentEntityClass.fromMap(c),
        );
      }

      debugPrint(
        "_handleGroupStudentReading: Loaded ${_allStudentsOfThisGroup.length} students",
      );
      emit(FeeAdminGroupStudentsLoadedState(dataList: _allStudentsOfThisGroup));
    } catch (e) {
      debugPrint("❌ ERROR in _handleGroupStudentReading: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleGroupStudentFiltering(
    FeeAdminGroupStudentsFilteringEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleGroupStudentFiltering: Query = '${event.query}'");
    debugPrint("========================================");

    var filteredGroupGroupStudents = _filterGroupGroupStudents(
      event.query,
      _allStudentsOfThisGroup,
    );

    debugPrint(
      "_handleGroupStudentFiltering: Filtered to ${filteredGroupGroupStudents.length} students",
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
      debugPrint(
        "_filterGroupGroupStudents: Empty query, returning all students",
      );
      return groupStudents;
    }

    final q = query.toLowerCase();
    debugPrint("_filterGroupGroupStudents: Filtering with query = '$q'");

    final result =
        groupStudents.where((groupStudents) {
          final name = (groupStudents.name ?? '').toLowerCase();
          final code =
              groupStudents.rollNum.isNotEmpty
                  ? groupStudents.rollNum
                  : ''.toLowerCase();
          return name.contains(q) || code.contains(q);
        }).toList();

    debugPrint("_filterGroupGroupStudents: Matched ${result.length} students");
    return result;
  }

  // ========================================
  // INSTALLMENT MANAGEMENT HANDLERS
  // ========================================
  void _onCalculateInstallment(
    InstallmentPageCalculateInst event,
    Emitter<FeeAdminState> emit,
  ) {
    debugPrint("========================================");
    debugPrint("_onCalculateInstallment: START");
    debugPrint("Total Fee: ${event.totalFee}");
    debugPrint("Installments: ${event.installments}");
    debugPrint("========================================");

    final totalFee = double.tryParse(event.totalFee);
    final installments = int.tryParse(event.installments);

    if (totalFee != null && installments != null && installments > 0) {
      final installmentAmount = totalFee / installments;
      debugPrint("_onCalculateInstallment: Result = $installmentAmount");

      emit(
        InstallmentPageInstallmentCalculatedState(
          installment: installmentAmount,
        ),
      );
    } else {
      debugPrint("⚠️ _onCalculateInstallment: Invalid input, returning 0");
      emit(InstallmentPageInstallmentCalculatedState(installment: 0));
    }
  }

  Future<void> _onCreateStudentInstallment(
    CreateStudentInstallmentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_onCreateStudentInstallment: START");
    debugPrint("Student ID: ${event.studentId}");
    debugPrint("Name: ${event.name}");
    debugPrint("Total Fee: ${event.totalFee}");
    debugPrint("Number of Installments: ${event.numberOfInstallments}");
    debugPrint("========================================");

    emit(InstallmentCreatingState());

    try {
      await actualImplemetationInstallmentRepo.createStudentWithInstallments(
        studentId: event.studentId,
        name: event.name,
        groupId: event.groupId,
        totalFee: event.totalFee,
        paidAmount: event.paidAmount,
        numberOfInstallments: event.numberOfInstallments,
        amountPerMonth: event.amountPerMonth,
      );

      debugPrint("✅ _onCreateStudentInstallment: SUCCESS");
      emit(InstallmentCreatedSuccessState());
    } catch (e) {
      debugPrint("❌ ERROR in _onCreateStudentInstallment: $e");
      emit(InstallmentCreatedFailureState(error: e.toString()));
    }
  }

  Future<void> _onGetStudent(
    GetStudentInstalmentEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_onGetStudent: Student ID = '${event.studentId}'");
    debugPrint("========================================");

    emit(StudentInstalmentLoadingState());

    try {
      final student = await feeadminreadinstalmentusecase.getStudent(
        event.studentId,
      );

      if (student != null) {
        debugPrint("✅ _onGetStudent: Student found");
        emit(StudentLoadedState(student));
      } else {
        debugPrint("⚠️ _onGetStudent: Student not found");
        emit(StudentLoadFailureState("Student not found"));
      }
    } catch (e) {
      debugPrint("❌ ERROR in _onGetStudent: $e");
      emit(StudentLoadFailureState(e.toString()));
    }
  }

  // ========================================
  // FEE HISTORY HANDLERS
  // ========================================
  Future<void> _onFetchFeesByDateRange(
    FetchFeesByDateRange event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_onFetchFeesByDateRange: START");
    debugPrint("Start Date: ${event.startDate}");
    debugPrint("End Date: ${event.endDate}");
    debugPrint("========================================");

    emit(FeeHistoryLoading());

    try {
      final fees = await actualImplemetationInstallmentRepo
          .fetchFeesByDateRange(event.startDate, event.endDate);

      debugPrint("_onFetchFeesByDateRange: Fetched ${fees.length} fees");

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

      debugPrint("========================================");
      debugPrint("_onFetchFeesByDateRange: Payment Breakdown:");
      debugPrint("  Cash Payment: $cashPaymentTotal");
      debugPrint("  JazzCash: $JazzCashTotal");
      debugPrint("  UBL: $UBLTotal");
      debugPrint("  EasyPaisa: $easyPaisaTotal");
      debugPrint("========================================");

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
      debugPrint("❌ ERROR in _onFetchFeesByDateRange: $e");
      emit(FeeHistoryError(e.toString()));
    }
  }

  Future<void> _onFetchTodayFees(
    FetchTodayFees event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_onFetchTodayFees: START");
    debugPrint("========================================");

    emit(FeeHistoryLoading());

    try {
      final fees = await actualImplemetationInstallmentRepo.fetchTodayFees();

      debugPrint("_onFetchTodayFees: Fetched ${fees.length} fees");

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

      debugPrint("========================================");
      debugPrint("_onFetchTodayFees: Payment Breakdown:");
      debugPrint("  Cash Payment: $cashPaymentTotal");
      debugPrint("  JazzCash: $JazzCashTotal");
      debugPrint("  UBL: $UBLTotal");
      debugPrint("  EasyPaisa: $easyPaisaTotal");
      debugPrint("========================================");

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
      debugPrint("❌ ERROR in _onFetchTodayFees: $e");
      emit(FeeHistoryError(e.toString()));
    }
  }

  // ========================================
  // NEW: DAY-WISE FEE HANDLER
  // ========================================
  Future<void> _onFetchDayWiseFees(
    FetchDayWiseFees event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_onFetchDayWiseFees: START");
    debugPrint("Start Date: ${event.startDate}");
    debugPrint("End Date: ${event.endDate}");
    debugPrint("========================================");

    emit(FeeHistoryLoading());

    try {
      final dayWiseFees = await _readDayWiseFeesUsecase.execute(
        event.startDate,
        event.endDate,
      );

      debugPrint(
        "_onFetchDayWiseFees: Received ${dayWiseFees.length} days of data",
      );

      if (dayWiseFees.isEmpty) {
        debugPrint("⚠️ WARNING: No day-wise fees found for the date range!");
      } else {
        debugPrint("Day-wise totals:");
        dayWiseFees.forEach((date, amount) {
          debugPrint("  ${date.toString().split(' ')[0]}: $amount");
        });
      }

      emit(
        DayWiseFeesLoaded(
          dayWiseFees: dayWiseFees,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    } catch (e) {
      debugPrint("❌ ERROR in _onFetchDayWiseFees: $e");
      emit(FeeHistoryError(e.toString()));
    }
  }

  // ========================================
  // FEE HISTORY ACTION HANDLERS
  // ========================================
  void _onUpdateSelectedDate(
    UpdateSelectedDate event,
    Emitter<FeeAdminState> emit,
  ) {
    debugPrint("========================================");
    debugPrint("_onUpdateSelectedDate: START");
    debugPrint("Start Date: ${event.startDate}");
    debugPrint("End Date: ${event.endDate}");
    debugPrint("========================================");

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
          JazzCashTotal: 0,
          UBLTotal: 0,
          cashPaymentTotal: 0,
          easyPaisaTotal: 0,
        ),
      );
    }
  }

  void _onSortFees(SortFees event, Emitter<FeeAdminState> emit) {
    debugPrint("========================================");
    debugPrint("_onSortFees: Sort Option = ${event.option}");
    debugPrint("========================================");

    if (state is FeeHistoryLoaded) {
      final s = state as FeeHistoryLoaded;
      final newList = List<FeeEntityClass>.from(s.fees);

      switch (event.option) {
        case SortOptionEnum.dateDesc:
          newList.sort((a, b) => b.date.compareTo(a.date));
          debugPrint("_onSortFees: Sorted by Date Descending");
          break;
        case SortOptionEnum.dateAsc:
          newList.sort((a, b) => a.date.compareTo(b.date));
          debugPrint("_onSortFees: Sorted by Date Ascending");
          break;
        case SortOptionEnum.amountDesc:
          newList.sort((a, b) => b.paidAmount.compareTo(a.paidAmount));
          debugPrint("_onSortFees: Sorted by Amount Descending");
          break;
        case SortOptionEnum.amountAsc:
          newList.sort((a, b) => a.paidAmount.compareTo(b.paidAmount));
          debugPrint("_onSortFees: Sorted by Amount Ascending");
          break;
      }

      emit(s.copyWith(fees: newList, sortOption: event.option));
    } else {
      debugPrint("⚠️ _onSortFees: State is not FeeHistoryLoaded");
    }
  }

  // ========================================
  // DEFAULTER MANAGEMENT HANDLERS
  // ========================================
  Future<void> _handleAddingFeeDefaulter(
    AddFeeDefaulterEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleAddingFeeDefaulter: START");
    debugPrint("Student ID: ${event.studentId}");
    debugPrint("Name: ${event.name}");
    debugPrint("Remaining Fee: ${event.remaingFee}");
    debugPrint("========================================");

    try {
      await addToFeeDefaulterUsecase.add(
        event.studentId,
        event.name,
        event.rollnum,
        event.remaingFee,
        event.group,
      );

      debugPrint("✅ _handleAddingFeeDefaulter: SUCCESS");
      emit(AddingFeeDefaulterCompleteState());
    } catch (e) {
      debugPrint("❌ ERROR in _handleAddingFeeDefaulter: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleReadingFeeDefaulter(
    ReadFeeDefaulterEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleReadingFeeDefaulter: Group ID = '${event.groupId}'");
    debugPrint("========================================");

    try {
      FeeDefaultersCollective feeDefaultersCollective =
          await readFeeDefaulterCollective.read(event.groupId);
      List<FeeDefaulterEntity> listOffeeDefaulterEntity =
          await readFeeDefaulterUsecase.read(event.groupId);

      debugPrint(
        "_handleReadingFeeDefaulter: Found ${listOffeeDefaulterEntity.length} defaulters",
      );

      emit(
        FeeDefaultersDataLoaded(
          listOFFeeDefaulterEntity: listOffeeDefaulterEntity,
          feeDefaultersCollective: feeDefaultersCollective,
          emittedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      debugPrint("❌ ERROR in _handleReadingFeeDefaulter: $e");
      emit(FeeAdminErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> _handleReadingGroupNames(
    ReadFeeDefaulterGroupsEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleReadingGroupNames: START");
    debugPrint("========================================");

    try {
      List<String> listOfGroupNames =
          await readGroupNamesFeeDefaultersUsecase.get();

      debugPrint(
        "_handleReadingGroupNames: Found ${listOfGroupNames.length} groups",
      );
      emit(GroupNamesReadCompleted(listOFGroupNames: listOfGroupNames));
    } catch (e) {
      debugPrint("❌ ERROR in _handleReadingGroupNames: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleRemovingStudentFromDefaulters(
    RemoveStudentFromDefaultersEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleRemovingStudentFromDefaulters: START");
    debugPrint("Group ID: ${event.groupId}");
    debugPrint("Student ID: ${event.studentId}");
    debugPrint("Paid Amount: ${event.paidAmount}");
    debugPrint("========================================");

    try {
      await _removeStudentFromDefaultersUsecase.remove(
        event.groupId,
        event.studentId,
        event.paidAmount,
        event.totalReaminingFeeForThisStudent,
      );

      debugPrint("✅ _handleRemovingStudentFromDefaulters: SUCCESS");
    } catch (e) {
      debugPrint("❌ ERROR in _handleRemovingStudentFromDefaulters: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleCheckingFeeDefaulter(
    CheckFeeDefaulterEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleCheckingFeeDefaulter: START");
    debugPrint("Group ID: ${event.groupId}");
    debugPrint("Student ID: ${event.studentId}");
    debugPrint("========================================");

    try {
      bool? isDefaulter = await _defaulterCheckUsecase.check(
        event.groupId,
        event.studentId,
      );

      debugPrint("_handleCheckingFeeDefaulter: Is Defaulter = $isDefaulter");
      emit(CheckingingFeeDefaulterCompleteState(isDefaulter: isDefaulter));
    } catch (e) {
      debugPrint("❌ ERROR in _handleCheckingFeeDefaulter: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  // ========================================
  // APPROVAL & PENDING FEE HANDLERS
  // ========================================
  Future<void> _handleAddingFeeInstallmentToSuperAdminApprovalList(
    AddToSuperAdminApprovalListEvent event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleAddingFeeInstallmentToSuperAdminApprovalList: START");
    debugPrint("Student ID: ${event.student.id}");
    debugPrint("Index: ${event.index}");
    debugPrint("========================================");

    try {
      await addToSuperAdminApprovalListUsecase.add(event.student, event.index);
      debugPrint(
        "✅ _handleAddingFeeInstallmentToSuperAdminApprovalList: SUCCESS",
      );
    } catch (e) {
      debugPrint(
        "❌ ERROR in _handleAddingFeeInstallmentToSuperAdminApprovalList: $e",
      );
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }

  Future<void> _handleAddingToPendingFee(
    AddToPendingFee2Event event,
    Emitter<FeeAdminState> emit,
  ) async {
    debugPrint("========================================");
    debugPrint("_handleAddingToPendingFee: START");
    debugPrint("Student ID: ${event.student.id}");
    debugPrint("Installment ID: ${event.instalment.id}");
    debugPrint("Paid Amount: ${event.paidAmount}");
    debugPrint("Payment Method: ${event.paymentMethod}");
    debugPrint("========================================");

    try {
      await addToPendingFee2.add(
        event.student,
        event.instalment,
        event.paidAmount,
        event.paymentMethod,
      );

      final StudentFeeFeatureEntityClass? student =
          await feeadminreadinstalmentusecase.getStudent(event.student.id);

      if (student != null) {
        debugPrint("✅ _handleAddingToPendingFee: SUCCESS");
        emit(AddedToPendingFee(student: student));
      } else {
        debugPrint(
          "⚠️ _handleAddingToPendingFee: Student not found after adding",
        );
        emit(
          FeeAdminErrorState(
            error: "Student not found after adding to pending fee",
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ ERROR in _handleAddingToPendingFee: $e");
      emit(FeeAdminErrorState(error: e.toString()));
    }
  }
}
