import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/repositories/abstract_group_repository.dart';

class UpdateGroupUsecase {
  final AbstractGroupRepository abstractGroupRepository;
  UpdateGroupUsecase({required this.abstractGroupRepository});

  Future<GroupEntity?> call({required String groupId, required GroupEntity groupEntity}) async {
    return await abstractGroupRepository.updateGroup(groupId, groupEntity);
  }
}