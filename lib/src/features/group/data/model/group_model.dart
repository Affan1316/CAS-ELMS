import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  GroupModel({
    required super.courseName,
    required super.enterDate,
    required super.enterDuration,
    required super.enterFee,
    required super.groupName,
  });

  Map<String, dynamic> toMap() {
    return {
      'CourseName': courseName,
      'GroupName': groupName,
      'EnterDate': enterDate,
      'EnterDuration': enterDuration,
      'EnterFee': enterFee,
    };
  }

  factory GroupModel.fromGroupEntity(GroupEntity groupEntity) {
    return GroupModel(
      courseName: groupEntity.courseName,
      enterDate: groupEntity.enterDate,
      enterDuration: groupEntity.enterDuration,
      enterFee: groupEntity.enterFee,
      groupName: groupEntity.groupName,
    );
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      courseName: map['CourseName'] ?? '',
      groupName: map['GroupName'] ?? '',
      enterDate: map['EnterDate'] ?? '',
      enterDuration: map['EnterDuration'] ?? '',
      enterFee:
          (map['EnterFee'] is int)
              ? (map['EnterFee'] as int).toDouble()
              : (map['EnterFee'] ?? 0.0),
    );
  }
}
