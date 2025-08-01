// ............................................................................

import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/sort_option.dart';

abstract class FeeHistoryEvent extends Equatable {
  const FeeHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadFees extends FeeHistoryEvent {}

class FilterByDate extends FeeHistoryEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterByDate({this.startDate, this.endDate});

  @override
  List<Object> get props => [startDate ?? '', endDate ?? ''];
}

class ResetFilters extends FeeHistoryEvent {}

class SortFees extends FeeHistoryEvent {
  final SortOption sortOption;

  const SortFees(this.sortOption);

  @override
  List<Object> get props => [sortOption];
}
