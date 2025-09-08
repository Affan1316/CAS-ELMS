import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/repositories/inquiry_repository.dart';

class GetInquiry {
  final InquiryRepository inquiryRepository;

  GetInquiry(this.inquiryRepository);

  Future<List<Inquiry>> call() {
    return inquiryRepository.getInquiries();
  }
}
