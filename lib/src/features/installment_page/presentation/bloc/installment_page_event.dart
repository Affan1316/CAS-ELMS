part of 'installment_page_bloc.dart';

abstract class InstallmentPageEvent extends Equatable {
  const InstallmentPageEvent();

  @override
  List<Object> get props => [];
}

class InstallmentPageCalculateInst extends InstallmentPageEvent {
  final String installments;
  final String totalFee;

  const InstallmentPageCalculateInst({
    required this.installments,
    required this.totalFee,
  });

  @override
  List<Object> get props => [installments, totalFee];
}

class CreateInstallmentEvent extends InstallmentPageEvent {
  final String studentId;
  final double totalFee;
  final int numberOfInstallments;
  final double amountPerMonth;

  const CreateInstallmentEvent({
    required this.studentId,
    required this.totalFee,
    required this.numberOfInstallments,
    required this.amountPerMonth,
  });

  @override
  List<Object> get props => [
    studentId,
    totalFee,
    numberOfInstallments,
    amountPerMonth,
  ];
}
