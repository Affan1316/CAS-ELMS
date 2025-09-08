
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';

class InquiryModel extends Inquiry{
  InquiryModel(
    {required super.id, 
    required super.studentName, 
    required super.fatherName, 
    required super.emailAddress, 
    required super.phoneNo, 
    required super.groupName, 
    required super.courseIntersted, 
    required super.gender});

    Map<String,dynamic> toMap(){
      return {
        'id': id,
        'studentName':studentName,
        'fatherName':fatherName,
        'emailAddress':emailAddress,
        'phoneNo':phoneNo,
        'groupName':groupName,
        'courseIntersted':courseIntersted,
        'gender':gender
      };
    }

  factory InquiryModel.fromMap(Map<String, dynamic> map) {
    return InquiryModel(
      id: map['id'] ?? '',
      studentName: map['studentName'] ?? '',
      fatherName: map['fatherName'] ?? '',
      emailAddress: map['emailAddress'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      groupName: map['groupName'] ?? '',
      courseIntersted: map['courseIntersted'] ?? '',
      gender: map['gender'] ?? '',
    );
  }

  
}
