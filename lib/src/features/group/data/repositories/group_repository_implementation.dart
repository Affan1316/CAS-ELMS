import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/group/data/model/group_model.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/repositories/abstract_group_repository.dart';

class GroupRepositoryImplementation extends AbstractGroupRepository {
  @override
  Future<void> addGroup(GroupEntity groupEntity) async {
    GroupModel groupModel = GroupModel.fromGroupEntity(groupEntity);
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupEntity.groupName)
        .set(groupModel.toMap());
  }

  @override
  Stream<List<GroupEntity>> fetchAllGroups() {
  return FirebaseFirestore.instance
      .collection('groups')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => GroupModel.fromMap(doc.data())).toList());
}

  @override
  Future<GroupEntity?> updateGroup(
  String groupId,
  GroupEntity groupEntity,
) async {
  GroupModel groupModel = GroupModel.fromGroupEntity(groupEntity);

  final docRef = FirebaseFirestore.instance.collection('groups').doc(groupId);

  // update the document
  await docRef.update(groupModel.toMap());

  // fetch the updated document
  final snapshot = await docRef.get();

  if (snapshot.exists) {
    return GroupModel.fromMap(snapshot.data()!);
  } else {
    return null; // document not found after update
  }
}

}
