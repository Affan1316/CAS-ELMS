class AdminHomeState {
  final int currentPage;
  final int pendingLeavesCount;
  final bool isLoadingLeaves;
  AdminHomeState({required this.currentPage, 
  this.pendingLeavesCount = 0,
  this.isLoadingLeaves = false
  });

  AdminHomeState copyWith({
    int? currentPage,
    int? pendingLeavesCount,
    bool? isLoadingLeaves,
    }) {
    return AdminHomeState(
      currentPage: currentPage ?? this.currentPage,
      pendingLeavesCount: pendingLeavesCount ?? this.pendingLeavesCount,
      isLoadingLeaves: isLoadingLeaves ?? this.isLoadingLeaves,);
  }
}
