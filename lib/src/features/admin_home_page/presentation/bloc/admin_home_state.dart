class AdminHomeState {
  final int currentPage;
  AdminHomeState({required this.currentPage});

  AdminHomeState copyWith({int? currentPage}) {
    return AdminHomeState(currentPage: currentPage ?? this.currentPage);
  }
}
