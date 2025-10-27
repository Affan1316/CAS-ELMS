abstract class AdminHomeEvent {}

class PageChangedEvent extends AdminHomeEvent {
  final int newPageIndex;
  PageChangedEvent(this.newPageIndex);
}

class LoadPendingLeavesEvent extends AdminHomeEvent {}
