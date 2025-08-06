part of 'installment_page_bloc.dart';

@immutable
abstract class InstallmentPageEvent {
  const InstallmentPageEvent();
}

class InstallmentPageCalculateInst extends InstallmentPageEvent {
  final String totalFee;
  final String installments;

  const InstallmentPageCalculateInst({
    required this.totalFee,
    required this.installments,
  });
}
