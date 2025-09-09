sealed class GroupStates {
  const GroupStates();
}

class GroupInitialState extends GroupStates {
  const GroupInitialState();
}

class GroupLoadingState extends GroupStates {
  const GroupLoadingState();
}

class GroupSubmittedState extends GroupStates {
  const GroupSubmittedState();
}

class GroupErrorState extends GroupStates {
  final String message;
  const GroupErrorState({required this.message});
}
