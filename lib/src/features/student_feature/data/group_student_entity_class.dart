// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StudentFeatureGroupStudentEntityClass {
  final String name;
  final String rollNum;
  final String profileImage;

  const StudentFeatureGroupStudentEntityClass({
    required this.name,
    required this.rollNum,
    required this.profileImage,
  });

  StudentFeatureGroupStudentEntityClass copyWith({
    String? name,
    String? rollNum,
    String? profileImage,
  }) {
    return StudentFeatureGroupStudentEntityClass(
      name: name ?? this.name,
      rollNum: rollNum ?? this.rollNum,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'rollNum': rollNum};
  }

  factory StudentFeatureGroupStudentEntityClass.fromMap(
    Map<String, dynamic> map,
  ) {
    return StudentFeatureGroupStudentEntityClass(
      name: map['name'] ?? '',
      rollNum: map['rollNum'] ?? '',
      profileImage: map['profile_image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentFeatureGroupStudentEntityClass.fromJson(String source) =>
      StudentFeatureGroupStudentEntityClass.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'GroupStudentEntityClass(name: $name, rollNum: $rollNum)';

  @override
  bool operator ==(covariant StudentFeatureGroupStudentEntityClass other) {
    if (identical(this, other)) return true;
    return other.name == name && other.rollNum == rollNum;
  }

  @override
  int get hashCode => name.hashCode ^ rollNum.hashCode;
}
