part of 'inquiry_bloc.dart';

@immutable
abstract class InquiryEvent {
  const InquiryEvent();
}

class LoadInquiries extends InquiryEvent {}

class InquiryTapEvent extends InquiryEvent {
  final int index;
  const InquiryTapEvent({required this.index});
}

class SubmitInquiry extends InquiryEvent {
  final String studentName;
  final String fatherName;
  final String emailAddress;
  final String phoneNo;
  final String groupName;
  final String courseIntersted;
  final String gender;

  const SubmitInquiry(
  this.studentName, 
  this.fatherName, 
  this.emailAddress, 
  this.phoneNo, 
  this.groupName, 
  this.courseIntersted, 
  this.gender);
}

class FetchInquiries extends InquiryEvent {}
