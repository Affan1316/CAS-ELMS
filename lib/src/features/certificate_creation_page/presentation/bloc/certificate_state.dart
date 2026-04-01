part of 'certificate_bloc.dart';

@immutable
sealed class CertificateState {}

final class CertificateInitial extends CertificateState {}

final class CertificateLoading extends CertificateState {}

final class CertificateSuccess extends CertificateState {
  final String message;
  CertificateSuccess(this.message);
}

final class CertificateError extends CertificateState {
  final String error;
  CertificateError(this.error);
}
