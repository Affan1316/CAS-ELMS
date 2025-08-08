import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'installment_page_event.dart';
part 'installment_page_state.dart';

class InstallmentPageBloc
    extends Bloc<InstallmentPageEvent, InstallmentPageState> {
  InstallmentPageBloc() : super(InstallmentPageInitialState()) {
    double installmentAmount = 0;

    on<InstallmentPageCalculateInst>((event, emit) {
      final total = double.tryParse(event.totalFee) ?? 0;
      final count = int.tryParse(event.installments) ?? 1;

      installmentAmount = count > 0 ? total / count : 0;

      emit(
        InstallmentPageintallmentCalculatedState(
          installment: installmentAmount,
        ),
      );
    });
  }
}
