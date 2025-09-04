import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';

abstract class GroupEvents {
  const GroupEvents();
}

class AddGroupEvent extends GroupEvents {
  final GroupEntity groupEntity;
  const AddGroupEvent({required this.groupEntity});
}

class UpdateGroupEvent extends GroupEvents {
  final GroupEntity groupEntity;
  final String groupId;
  const UpdateGroupEvent({required this.groupId, required this.groupEntity});
}
