// ............................................................................

// import 'package:flutter_application_cas/fee.dart';
// import 'package:flutter_application_cas/fee_history_error.dart';
// import 'package:flutter_application_cas/fee_history_event.dart';
// import 'package:flutter_application_cas/fee_history_initial.dart';
// import 'package:flutter_application_cas/fee_history_loaded.dart';
// import 'package:flutter_application_cas/fee_history_loading.dart';
// import 'package:flutter_application_cas/fee_history_state.dart';
// import 'package:flutter_application_cas/fee_service.dart';
// import 'package:flutter_application_cas/filter_by_date.dart';
// import 'package:flutter_application_cas/load_fees.dart';
// import 'package:flutter_application_cas/main.dart';
// import 'package:flutter_application_cas/reset_filters.dart';
// import 'package:flutter_application_cas/sort_fees.dart';
// import 'package:flutter_application_cas/sort_option.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee_service.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/sort_option.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_event.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/presentation/bloc/fee_history_state.dart';

class FeeHistoryBloc extends Bloc<FeeHistoryEvent, FeeHistoryState> {
  final FeeService feeService;

  FeeHistoryBloc(this.feeService) : super(FeeHistoryInitial()) {
    on<LoadFees>(_onLoadFees);
    on<FilterByDate>(_onFilterByDate);
    on<SortFees>(_onSortFees);
    on<ResetFilters>(_onResetFilters);
  }

  Future<void> _onLoadFees(
    LoadFees event,
    Emitter<FeeHistoryState> emit,
  ) async {
    emit(FeeHistoryLoading());
    try {
      final fees = await feeService.getFees();
      emit(FeeHistoryLoaded(allFees: fees, filteredFees: fees));
    } catch (e) {
      emit(FeeHistoryError(e.toString()));
    }
  }

  void _onFilterByDate(FilterByDate event, Emitter<FeeHistoryState> emit) {
    if (state is! FeeHistoryLoaded) return;
    final currentState = state as FeeHistoryLoaded;
    List<Fee> filteredFees = List<Fee>.from(currentState.allFees);

    if (event.startDate != null) {
      filteredFees =
          filteredFees
              .where((fee) => !fee.date.isBefore(event.startDate!))
              .toList();
    }
    if (event.endDate != null) {
      filteredFees =
          filteredFees
              .where((fee) => !fee.date.isAfter(event.endDate!))
              .toList();
    }

    // Apply current sort option
    _applySorting(filteredFees, currentState.sortOption);

    emit(
      currentState.copyWith(
        startDate: event.startDate,
        endDate: event.endDate,
        filteredFees: filteredFees,
      ),
    );
  }

  void _onSortFees(SortFees event, Emitter<FeeHistoryState> emit) {
    if (state is! FeeHistoryLoaded) return;
    final currentState = state as FeeHistoryLoaded;
    List<Fee> filteredFees = List<Fee>.from(currentState.filteredFees);

    _applySorting(filteredFees, event.sortOption);

    emit(
      currentState.copyWith(
        sortOption: event.sortOption,
        filteredFees: filteredFees,
      ),
    );
  }

  void _onResetFilters(ResetFilters event, Emitter<FeeHistoryState> emit) {
    if (state is! FeeHistoryLoaded) return;
    final currentState = state as FeeHistoryLoaded;
    List<Fee> filteredFees = List<Fee>.from(currentState.allFees);

    _applySorting(filteredFees, SortOption.dateNewestFirst);

    emit(
      const FeeHistoryLoaded(
        allFees: [],
        filteredFees: [],
        sortOption: SortOption.dateNewestFirst,
      ),
    );

    // Reload fees
    add(LoadFees());
  }

  void _applySorting(List<Fee> fees, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.dateNewestFirst:
        fees.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.dateOldestFirst:
        fees.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.amountHighestFirst:
        fees.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.amountLowestFirst:
        fees.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
  }
}
