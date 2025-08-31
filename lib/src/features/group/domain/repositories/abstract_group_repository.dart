import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';

abstract class AbstractGroupRepository {
  Future<void> addGroup(GroupEntity groupEntity);
  Stream<List<GroupEntity>> fetchAllGroups();
  Future<GroupEntity?> updateGroup(String groupId, GroupEntity groupEntity);
}
