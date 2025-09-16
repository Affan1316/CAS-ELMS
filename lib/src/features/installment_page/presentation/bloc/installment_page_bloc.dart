// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_cas_app_main/src/features/installment_page/presentation/fee_installment.dart';
// import 'package:flutter_cas_app_main/src/features/installment_page/presentation/installment_service.dart';

// part 'installment_page_event.dart';
// part 'installment_page_state.dart';

// class InstallmentPageBloc
//     extends Bloc<InstallmentPageEvent, InstallmentPageState> {
//   final InstallmentService _installmentService;

//   InstallmentPageBloc({required InstallmentService installmentService})
//     : _installmentService = installmentService,
//       super(InstallmentPageInitial()) {
//     on<InstallmentPageCalculateInst>(_onCalculateInstallment);
//     on<CreateInstallmentEvent>(_onCreateInstallment);
//   }

//   void _onCalculateInstallment(
//     InstallmentPageCalculateInst event,
//     Emitter<InstallmentPageState> emit,
//   ) {
//     final totalFee = double.tryParse(event.totalFee);
//     final installments = int.tryParse(event.installments);

//     if (totalFee != null && installments != null && installments > 0) {
//       final installmentAmount = totalFee / installments;
//       emit(
//         InstallmentPageintallmentCalculatedState(
//           installment: installmentAmount,
//         ),
//       );
//     } else {
//       emit(InstallmentPageintallmentCalculatedState(installment: 0));
//     }
//   }

//   Future<void> _onCreateInstallment(
//     CreateInstallmentEvent event,
//     Emitter<InstallmentPageState> emit,
//   ) async {
//     emit(InstallmentCreatingState());

//     try {
//       await _installmentService.createInstallmentPlan(
//         studentId: event.studentId,
//         totalFee: event.totalFee,
//         numberOfInstallments: event.numberOfInstallments,
//         amountPerMonth: event.amountPerMonth,
//       );

//       emit(InstallmentCreatedSuccessState());
//     } catch (e) {
//       emit(InstallmentCreatedFailureState(error: e.toString()));
//     }
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_event.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/bloc/installment_page_state.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/fee_installment.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/installment_service.dart';

class InstallmentPageBloc
    extends Bloc<InstallmentPageEvent, InstallmentPageState> {
  final InstallmentService _installmentService;

  InstallmentPageBloc({required InstallmentService installmentService})
    : _installmentService = installmentService,
      super(InstallmentPageInitial()) {
    on<InstallmentPageCalculateInst>(_onCalculateInstallment);
    on<CreateStudentInstallmentEvent>(_onCreateStudentInstallment);
    on<GetStudentEvent>(_onGetStudent);
  }

  /// ✅ Handle fee calculation
  void _onCalculateInstallment(
    InstallmentPageCalculateInst event,
    Emitter<InstallmentPageState> emit,
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
      emit(const InstallmentPageInstallmentCalculatedState(installment: 0));
    }
  }

  /// ✅ Create a student with installments
  Future<void> _onCreateStudentInstallment(
    CreateStudentInstallmentEvent event,
    Emitter<InstallmentPageState> emit,
  ) async {
    emit(InstallmentCreatingState());

    try {
      await _installmentService.createStudentWithInstallments(
        studentId: event.studentId,
        name: event.name,
        groupId: event.groupId,
        totalFee: event.totalFee,
        numberOfInstallments: event.numberOfInstallments,
      );

      emit(InstallmentCreatedSuccessState());
    } catch (e) {
      emit(InstallmentCreatedFailureState(error: e.toString()));
    }
  }

  /// ✅ Fetch a student from Firestore
  Future<void> _onGetStudent(
    GetStudentEvent event,
    Emitter<InstallmentPageState> emit,
  ) async {
    emit(StudentLoadingState());

    try {
      final student = await _installmentService.getStudent(event.studentId);

      if (student != null) {
        emit(StudentLoadedState(student));
      } else {
        emit(const StudentLoadFailureState("Student not found"));
      }
    } catch (e) {
      emit(StudentLoadFailureState(e.toString()));
    }
  }
}
