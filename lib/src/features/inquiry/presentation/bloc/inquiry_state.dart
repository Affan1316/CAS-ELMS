part of 'inquiry_bloc.dart';

@immutable
abstract class InquiryState {}

class InquiryInitial extends InquiryState {}

class InquiryLoading extends InquiryState {}

class InquirySuccess extends InquiryState {}

class InquiryLoaded extends InquiryState {
  final List<Inquiry> inquiries;
  final int? selectedIndex;
  final bool isExpanded;

  InquiryLoaded({
    required this.inquiries,
    this.selectedIndex,
    this.isExpanded = false,
  });
}

class InquiryError extends InquiryState {
  final String message;
  InquiryError(this.message);
}

class InquiryFailure extends InquiryState {
  final String message;
  InquiryFailure(this.message);
}

class InquiryListLoading extends InquiryState {}

class InquiryListLoaded extends InquiryState {
  final List<Inquiry> inquiries;
  InquiryListLoaded(this.inquiries);
}

class InquiryListError extends InquiryState {
  final String message;
  InquiryListError(this.message);
}



