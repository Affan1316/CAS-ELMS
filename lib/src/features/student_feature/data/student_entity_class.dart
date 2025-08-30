// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StudentEntityClass {
  final String id;
  final String name;
  final String email;
  final String cnic;
  final String phone;
  final String address;
  final String gender;
  final String fatherName;
  final String fatherOccupation;
  final String group;
  StudentEntityClass({
    required this.id,
    required this.name,
    required this.email,
    required this.cnic,
    required this.phone,
    required this.address,
    required this.gender,
    required this.fatherName,
    required this.fatherOccupation,
    required this.group,
  });

  StudentEntityClass copyWith({
    String? id,
    String? name,
    String? email,
    String? cnic,
    String? phone,
    String? address,
    String? gender,
    String? fatherName,
    String? fatherOccupation,
    String? group,
  }) {
    return StudentEntityClass(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cnic: cnic ?? this.cnic,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      fatherName: fatherName ?? this.fatherName,
      fatherOccupation: fatherOccupation ?? this.fatherOccupation,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'cnic': cnic,
      'phone': phone,
      'address': address,
      'gender': gender,
      'fatherName': fatherName,
      'fatherOccupation': fatherOccupation,
      'group': group,
    };
  }

  factory StudentEntityClass.fromMap(Map<String, dynamic> map) {
    return StudentEntityClass(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      cnic: map['cnic'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      gender: map['gender'] as String,
      fatherName: map['fatherName'] as String,
      fatherOccupation: map['fatherOccupation'] as String,
      group: map['group'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentEntityClass.fromJson(String source) =>
      StudentEntityClass.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(id: $id, name: $name, email: $email, cnic: $cnic, phone: $phone, address: $address, gender: $gender, fatherName: $fatherName, fatherOccupation: $fatherOccupation, group: $group)';
  }

  @override
  bool operator ==(covariant StudentEntityClass other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.cnic == cnic &&
        other.phone == phone &&
        other.address == address &&
        other.gender == gender &&
        other.fatherName == fatherName &&
        other.fatherOccupation == fatherOccupation &&
        other.group == group;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        cnic.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        gender.hashCode ^
        fatherName.hashCode ^
        fatherOccupation.hashCode ^
        group.hashCode;
  }
}
