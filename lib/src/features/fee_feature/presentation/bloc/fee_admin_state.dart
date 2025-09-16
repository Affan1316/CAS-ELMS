import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';

abstract class FeeAdminState {}

class FeeAdminInitialState extends FeeAdminState {}

class FeeAdminGroupsLoadingState extends FeeAdminState {}

class FeeAdminGroupsLoadedState extends FeeAdminState {
  final List<GroupEntity> groups;
  FeeAdminGroupsLoadedState({required this.groups});
}

class FeeAdminGroupDataFilteringCompleteState extends FeeAdminState {
  final List<GroupEntity> filteredDataList;
  FeeAdminGroupDataFilteringCompleteState({required this.filteredDataList});
}

class FeeAdminErrorState extends FeeAdminState {
  final String error;

  FeeAdminErrorState({required this.error});

  @override
  String toString() => "FeeAdminErrorState: $error";
}

class FeeAdminGroupsStudentsLoadingState extends FeeAdminState {}

class FeeAdminGroupStudentsLoadedState extends FeeAdminState {
  final List<StudentFeatureGroupStudentEntityClass> dataList;
  FeeAdminGroupStudentsLoadedState({required this.dataList});
}

class FeeAdminGroupStudentsFilteringCompleteState extends FeeAdminState {
  final List<StudentFeatureGroupStudentEntityClass> filteredDataList;
  FeeAdminGroupStudentsFilteringCompleteState({required this.filteredDataList});
}
