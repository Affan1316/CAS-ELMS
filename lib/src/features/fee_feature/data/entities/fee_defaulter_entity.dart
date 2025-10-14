// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeeDefaulterEntity {
  String name;
  num remaingFee;
  String rollnum;
  FeeDefaulterEntity({
    required this.name,
    required this.remaingFee,
    required this.rollnum,
  });

  FeeDefaulterEntity copyWith({
    String? name,
    num? remaingFee,
    String? rollnum,
  }) {
    return FeeDefaulterEntity(
      name: name ?? this.name,
      remaingFee: remaingFee ?? this.remaingFee,
      rollnum: rollnum ?? this.rollnum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'remaingFee': remaingFee,
      'rollnum': rollnum,
    };
  }

  factory FeeDefaulterEntity.fromMap(Map<String, dynamic> map) {
    return FeeDefaulterEntity(
      name: map['name'] as String,
      remaingFee: map['remaingFee'] as num,
      rollnum: map['rollnum'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeeDefaulterEntity.fromJson(String source) =>
      FeeDefaulterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FeeDefaulterEntity(name: $name, remaingFee: $remaingFee, rollnum: $rollnum)';

  @override
  bool operator ==(covariant FeeDefaulterEntity other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.remaingFee == remaingFee &&
        other.rollnum == rollnum;
  }

  @override
  int get hashCode => name.hashCode ^ remaingFee.hashCode ^ rollnum.hashCode;
}
