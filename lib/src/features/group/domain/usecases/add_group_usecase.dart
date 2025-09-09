import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/repositories/abstract_group_repository.dart';

class AddGroupUsecase {
  final AbstractGroupRepository abstractGroupRepository;
  AddGroupUsecase({required this.abstractGroupRepository});

  Future<void> call({required GroupEntity groupEntity}) async {
    return await abstractGroupRepository.addGroup(groupEntity);
  }
}
