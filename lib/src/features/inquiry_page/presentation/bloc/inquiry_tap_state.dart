class InquiryState {
  const InquiryState();
}

class InquiryTapState extends InquiryState {
  final bool isExpanded;
  final int index;
  final int? selectedIndex;
  const InquiryTapState({
    required this.isExpanded,
    required this.index,
    required this.selectedIndex,
  });
}
