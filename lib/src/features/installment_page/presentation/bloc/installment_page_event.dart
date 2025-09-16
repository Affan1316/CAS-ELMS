// part of 'installment_page_bloc.dart';

// abstract class InstallmentPageEvent extends Equatable {
//   const InstallmentPageEvent();

//   @override
//   List<Object> get props => [];
// }

// class InstallmentPageCalculateInst extends InstallmentPageEvent {
//   final String installments;
//   final String totalFee;

//   const InstallmentPageCalculateInst({
//     required this.installments,
//     required this.totalFee,
//   });

//   @override
//   List<Object> get props => [installments, totalFee];
// }

// class CreateInstallmentEvent extends InstallmentPageEvent {
//   final String studentId;
//   final double totalFee;
//   final int numberOfInstallments;
//   final double amountPerMonth;

//   const CreateInstallmentEvent({
//     required this.studentId,
//     required this.totalFee,
//     required this.numberOfInstallments,
//     required this.amountPerMonth,
//   });

//   @override
//   List<Object> get props => [
//     studentId,
//     totalFee,
//     numberOfInstallments,
//     amountPerMonth,
//   ];
// }

import 'package:equatable/equatable.dart';

abstract class InstallmentPageEvent extends Equatable {
  const InstallmentPageEvent();

  @override
  List<Object?> get props => [];
}

/// ✅ Calculate per-installment amount
class InstallmentPageCalculateInst extends InstallmentPageEvent {
  final String installments;
  final String totalFee;

  const InstallmentPageCalculateInst({
    required this.installments,
    required this.totalFee,
  });

  @override
  List<Object?> get props => [installments, totalFee];
}

/// ✅ Create a student with installments
class CreateStudentInstallmentEvent extends InstallmentPageEvent {
  final String studentId;
  final String name;
  final String groupId;
  final double totalFee;
  final int numberOfInstallments;

  const CreateStudentInstallmentEvent({
    required this.studentId,
    required this.name,
    required this.groupId,
    required this.totalFee,
    required this.numberOfInstallments,
  });

  @override
  List<Object?> get props => [
    studentId,
    name,
    groupId,
    totalFee,
    numberOfInstallments,
  ];
}

/// ✅ Fetch student data
class GetStudentEvent extends InstallmentPageEvent {
  final String studentId;

  const GetStudentEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
