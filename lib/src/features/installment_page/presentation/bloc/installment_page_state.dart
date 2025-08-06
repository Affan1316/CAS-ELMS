part of 'installment_page_bloc.dart';

@immutable
abstract class InstallmentPageState {
  const InstallmentPageState();
}

@immutable
class InstallmentPageInitialState extends InstallmentPageState {
  const InstallmentPageInitialState();
}

@immutable
class InstallmentPageintallmentCalculatedState extends InstallmentPageState {
  final double installment;
  const InstallmentPageintallmentCalculatedState({required this.installment});
}
