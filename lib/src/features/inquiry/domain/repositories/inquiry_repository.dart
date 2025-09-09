
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';

abstract class InquiryRepository {
  Future<void> addInquiry(Inquiry inquiry);
  Future<List<Inquiry>> getInquiries();
}
