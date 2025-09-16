import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/installment_service.dart';
import 'package:meta/meta.dart';

part 'installment_page_event.dart';
part 'installment_page_state.dart';

class InstallmentPageBloc
    extends Bloc<InstallmentPageEvent, InstallmentPageState> {
  final InstallmentService _installmentService;

  InstallmentPageBloc({required InstallmentService installmentService})
    : _installmentService = installmentService,
      super(InstallmentPageInitial()) {
    on<InstallmentPageCalculateInst>(_onCalculateInstallment);
    on<CreateInstallmentEvent>(_onCreateInstallment);
  }

  void _onCalculateInstallment(
    InstallmentPageCalculateInst event,
    Emitter<InstallmentPageState> emit,
  ) {
    final totalFee = double.tryParse(event.totalFee);
    final installments = int.tryParse(event.installments);

    if (totalFee != null && installments != null && installments > 0) {
      final installmentAmount = totalFee / installments;
      emit(
        InstallmentPageintallmentCalculatedState(
          installment: installmentAmount,
        ),
      );
    } else {
      emit(InstallmentPageintallmentCalculatedState(installment: 0));
    }
  }

  Future<void> _onCreateInstallment(
    CreateInstallmentEvent event,
    Emitter<InstallmentPageState> emit,
  ) async {
    emit(InstallmentCreatingState());

    try {
      await _installmentService.createInstallmentPlan(
        studentId: event.studentId,
        totalFee: event.totalFee,
        numberOfInstallments: event.numberOfInstallments,
        amountPerMonth: event.amountPerMonth,
      );

      emit(InstallmentCreatedSuccessState());
    } catch (e) {
      emit(InstallmentCreatedFailureState(error: e.toString()));
    }
  }
}
