import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/repositories/inquiry_repository.dart';

class CreateInquiry {
  final InquiryRepository inquiryRepository;

  CreateInquiry(this.inquiryRepository);

  Future<void> call(Inquiry inquiry) {
    return inquiryRepository.addInquiry(inquiry);
  }
}
