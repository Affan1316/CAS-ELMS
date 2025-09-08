import 'package:bloc/bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/entities/inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/usecases/create_inquiry.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/domain/usecases/get_inquiry.dart';
import 'package:meta/meta.dart';
part 'inquiry_event.dart';
part 'inquiry_state.dart';

class InquiryBloc extends Bloc<InquiryEvent, InquiryState> {
  final CreateInquiry createInquiry;
  final GetInquiry getInquiry;

  InquiryBloc(this.createInquiry, this.getInquiry) : super(InquiryInitial()) {
    on<LoadInquiries>((event, emit) async {
      emit(InquiryLoading());
      try {
        final result = await getInquiry();
        emit(InquiryLoaded(inquiries: result));
      } catch (e) {
        emit(InquiryError("Failed to load inquiries: $e"));
      }
    });


    on<InquiryTapEvent>((event, emit) {
      if (state is InquiryLoaded) {
        final current = state as InquiryLoaded;
        final isSame = current.selectedIndex == event.index;
        emit(InquiryLoaded(
          inquiries: current.inquiries,
          selectedIndex: isSame ? null : event.index,
          isExpanded: !isSame,
        ));
      }
    });  


    on<SubmitInquiry>((event, emit) async {
      emit(InquiryLoading());
      try {
        final inquiry = Inquiry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          studentName: event.studentName,
          fatherName: event.fatherName,
          emailAddress: event.emailAddress,
          phoneNo: event.phoneNo,
          groupName: event.groupName,
          courseIntersted: event.courseIntersted,
          gender: event.gender,
        );
        await createInquiry(inquiry);
        emit(InquirySuccess());
      } catch (e) {
        emit(InquiryFailure(e.toString()));
      }
    });

    on<FetchInquiries>((event, emit) async {
      emit(InquiryListLoading());
      try {
        final List<Inquiry> inquiries = await getInquiry();
        emit(InquiryListLoaded(inquiries));
      } catch (e) {
        emit(InquiryListError(e.toString()));
      }
    });
  }
}
