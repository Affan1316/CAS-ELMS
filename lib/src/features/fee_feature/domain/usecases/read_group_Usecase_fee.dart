import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/read_group_usecase.dart';

class ReadGroupUsecaseFee {
  final ReadGroupUsecase UsecaseGroupFeature = ReadGroupUsecase(
    abstractGroupRepository: GroupRepositoryImplementation(),
  );
  Stream<List<GroupEntity>> getGroups() {
    return UsecaseGroupFeature.call();
  }
}
