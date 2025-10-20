import 'package:flutter_cas_app_main/src/features/student_feature/domain/get_groups_names_usecase.dart';

class GetGroupsNamesSuperAdminUsecase {
  final GetGroupsNamesUsecase orignalUsecase;

  GetGroupsNamesSuperAdminUsecase({required this.orignalUsecase});
  getNames() {
    return orignalUsecase.getGroupNames();
  }
}
