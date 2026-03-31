part of 'certificate_bloc.dart';

@immutable
sealed class CertificateEvent {}

class CreateAndShareCertificate extends CertificateEvent {
  final String employeeName;
  final String jobRole;
  final String startDate;
  final String endDate;

  CreateAndShareCertificate({
    required this.employeeName,
    required this.jobRole,
    required this.startDate,
    required this.endDate,
  });
}
