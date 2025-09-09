// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GroupStudentEntityClass {
  final String name;
  final String rollNum;

  const GroupStudentEntityClass({required this.name, required this.rollNum});

  GroupStudentEntityClass copyWith({String? name, String? rollNum}) {
    return GroupStudentEntityClass(
      name: name ?? this.name,
      rollNum: rollNum ?? this.rollNum,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'rollNum': rollNum};
  }

  factory GroupStudentEntityClass.fromMap(Map<String, dynamic> map) {
    return GroupStudentEntityClass(
      name: map['name'] ?? '',
      rollNum: map['rollNum'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupStudentEntityClass.fromJson(String source) =>
      GroupStudentEntityClass.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'GroupStudentEntityClass(name: $name, rollNum: $rollNum)';

  @override
  bool operator ==(covariant GroupStudentEntityClass other) {
    if (identical(this, other)) return true;
    return other.name == name && other.rollNum == rollNum;
  }

  @override
  int get hashCode => name.hashCode ^ rollNum.hashCode;
}
