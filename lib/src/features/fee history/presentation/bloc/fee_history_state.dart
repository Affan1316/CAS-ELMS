// ............................................................................

import 'package:equatable/equatable.dart';

import 'package:flutter_cas_app_main/src/features/fee%20history/data/fee.dart';
import 'package:flutter_cas_app_main/src/features/fee%20history/data/sort_option.dart';

abstract class FeeHistoryState extends Equatable {
  const FeeHistoryState();

  @override
  List<Object> get props => [];
}

class FeeHistoryLoading extends FeeHistoryState {}

class FeeHistoryLoaded extends FeeHistoryState {
  final List<Fee> allFees;
  final List<Fee> filteredFees;
  final DateTime? startDate;
  final DateTime? endDate;
  final SortOption sortOption;

  const FeeHistoryLoaded({
    required this.allFees,
    required this.filteredFees,
    this.startDate,
    this.endDate,
    this.sortOption = SortOption.dateNewestFirst,
  });

  @override
  List<Object> get props => [
    allFees,
    filteredFees,
    startDate ?? '',
    endDate ?? '',
    sortOption,
  ];

  FeeHistoryLoaded copyWith({
    List<Fee>? allFees,
    List<Fee>? filteredFees,
    DateTime? startDate,
    DateTime? endDate,
    SortOption? sortOption,
  }) {
    return FeeHistoryLoaded(
      allFees: allFees ?? this.allFees,
      filteredFees: filteredFees ?? this.filteredFees,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

class FeeHistoryError extends FeeHistoryState {
  final String message;

  const FeeHistoryError(this.message);

  @override
  List<Object> get props => [message];
}

class FeeHistoryInitial extends FeeHistoryState {}
