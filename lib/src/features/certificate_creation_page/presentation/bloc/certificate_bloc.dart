import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/certificate_service.dart';

part 'certificate_event.dart';
part 'certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final CertificateService _certificateService = CertificateService();

  CertificateBloc() : super(CertificateInitial()) {
    on<CreateAndShareCertificate>((event, emit) async {
      emit(CertificateLoading());
      try {
        await _certificateService.fillAndShareCertificate(
          employeeName: event.employeeName,
          jobRole: event.jobRole,
          startDate: event.startDate,
          endDate: event.endDate,
        );
        emit(
          CertificateSuccess(
            "Certificate created and shared successfully for ${event.employeeName}",
          ),
        );
      } catch (e) {
        log("Error generating certificate: $e");
        emit(
          CertificateError("Failed to generate certificate: ${e.toString()}"),
        );
      }
    });
  }
}
