import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

@immutable
class InquiryEvent {
  const InquiryEvent();
}

@immutable
class InquiryTapEvent extends InquiryEvent {
  final int index;
  final int? selectedIndex;
  const InquiryTapEvent({required this.index, required this.selectedIndex});
}
