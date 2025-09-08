import 'package:flutter_cas_app_main/src/features/inquiry/data/datasources/inquiry_remote_data_source.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/data/model/inquiry_model.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/repositories/inquiry_repository.dart';

class InquiryRepositoryImpl implements InquiryRepository {
  final InquiryRemoteDataSource remoteDataSource;

  InquiryRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addInquiry(Inquiry inquiry) {
    final model = InquiryModel(
      id: inquiry.id,
      studentName: inquiry.studentName,
      fatherName: inquiry.fatherName,
      emailAddress: inquiry.emailAddress,
      phoneNo: inquiry.phoneNo,
      groupName: inquiry.groupName,
      courseIntersted: inquiry.courseIntersted,
      gender: inquiry.gender,
    );
    return remoteDataSource.addInquiry(model);
  }

  @override
  Future<List<InquiryModel>> getInquiries() async {
    final models = await remoteDataSource.getInquiries();
    return models;
  }
}
