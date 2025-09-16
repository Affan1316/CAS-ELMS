import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';

abstract class FeeAdminEvent {}

class FeeAdminFetchGroupsEvent extends FeeAdminEvent {}

class FeeAdminGroupDataFilteringEvent extends FeeAdminEvent {
  final String query;
  FeeAdminGroupDataFilteringEvent({required this.query});
}

class FeeAdminFetchGroupsStudentEvent extends FeeAdminEvent {
  final String groupTitle;
  FeeAdminFetchGroupsStudentEvent({required this.groupTitle});
}

class FeeAdminGroupStudentsFilteringEvent extends FeeAdminEvent {
  final String query;
  FeeAdminGroupStudentsFilteringEvent({required this.query});
}
