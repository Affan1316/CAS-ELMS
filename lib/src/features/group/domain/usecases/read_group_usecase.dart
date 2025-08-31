import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/repositories/abstract_group_repository.dart';

class ReadGroupUsecase {
  AbstractGroupRepository abstractGroupRepository;

  ReadGroupUsecase({required this.abstractGroupRepository});

  Stream<List<GroupEntity>> call() {
    return  abstractGroupRepository.fetchAllGroups();
  }
}
