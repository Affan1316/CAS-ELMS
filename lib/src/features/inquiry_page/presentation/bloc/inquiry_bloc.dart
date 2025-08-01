import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/bloc/inquiry_tap_event.dart';
import 'package:flutter_cas_app_main/src/features/inquiry_page/presentation/bloc/inquiry_tap_state.dart';

class InquiryBloc extends Bloc<InquiryEvent, InquiryState> {
  InquiryBloc() : super(InquiryState()) {
    on<InquiryTapEvent>((event, emit) {
      int? selectedIndex = event.selectedIndex;
      final int tappedIndex = event.index;

      if (selectedIndex == tappedIndex) {
        // Collapse the tapped item
        emit(
          InquiryTapState(
            isExpanded: false,
            index: tappedIndex,
            selectedIndex: null,
          ),
        );
      } else {
        // Expand only the tapped item
        emit(
          InquiryTapState(
            isExpanded: true,
            index: tappedIndex,
            selectedIndex: tappedIndex,
          ),
        );
      }
    });
  }
}
