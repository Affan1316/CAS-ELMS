// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Inquiry {
  final String name;
  final String id;
  final String? batchName;
  final String? course;
  final String? phone;
  final String? email;
  final bool isConfirmed;
  final DateTime date;

  Inquiry({
    required this.name,
    required this.id,
    this.batchName,
    this.course,
    this.phone,
    this.email,
    required this.isConfirmed,
    required this.date,
  });

  Inquiry copyWith({
    String? name,
    String? id,
    String? batchName,
    String? course,
    String? phone,
    String? email,
    bool? isConfirmed,
    DateTime? date,
  }) {
    return Inquiry(
      name: name ?? this.name,
      id: id ?? this.id,
      batchName: batchName ?? this.batchName,
      course: course ?? this.course,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'batchName': batchName,
      'course': course,
      'phone': phone,
      'email': email,
      'isConfirmed': isConfirmed,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Inquiry.fromMap(Map<String, dynamic> map) {
    return Inquiry(
      name: map['name'] as String,
      id: map['id'] as String,
      batchName: map['batchName'] != null ? map['batchName'] as String : null,
      course: map['course'] != null ? map['course'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      isConfirmed: map['isConfirmed'] as bool,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Inquiry.fromJson(String source) =>
      Inquiry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Inquiry(name: $name, id: $id, batchName: $batchName, course: $course, phone: $phone, email: $email, isConfirmed: $isConfirmed, date: $date)';
  }

  @override
  bool operator ==(covariant Inquiry other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.id == id &&
        other.batchName == batchName &&
        other.course == course &&
        other.phone == phone &&
        other.email == email &&
        other.isConfirmed == isConfirmed &&
        other.date == date;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        id.hashCode ^
        batchName.hashCode ^
        course.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        isConfirmed.hashCode ^
        date.hashCode;
  }
}

final inquiries = [
  Inquiry(
    name: 'John Doe',
    id: '12345',
    batchName: 'Batch A',
    course: 'Flutter Development',
    phone: '123-456-7890',
    email: 'john.doe@example.com',
    isConfirmed: true,
    date: DateTime(2023, 10, 26),
  ),
  Inquiry(
    name: 'Jane Smith',
    id: '67890',
    batchName: 'Batch B',
    course: 'UI/UX Design',
    phone: '098-765-4321',
    email: 'jane.smith@example.com',
    isConfirmed: false,
    date: DateTime(2023, 10, 25),
  ),
  Inquiry(
    name: 'Peter Jones',
    id: '11223',
    batchName: 'Batch A',
    course: 'Flutter Development',
    phone: '555-123-4567',
    email: 'peter.jones@example.com',
    isConfirmed: true,
    date: DateTime(2023, 10, 24),
  ),
  Inquiry(
    name: 'Alice Brown',
    id: '44556',
    isConfirmed: false,
    date: DateTime(2023, 10, 23),
  ),
  Inquiry(
    name: 'Bob White',
    id: '77889',
    batchName: 'Batch C',
    course: 'Data Science',
    phone: '222-333-4444',
    email: 'bob.white@example.com',
    isConfirmed: true,
    date: DateTime(2023, 10, 22),
  ),
  Inquiry(
    name: 'Charlie Green',
    id: '99001',
    isConfirmed: false,
    date: DateTime(2023, 10, 21),
  ),
  Inquiry(
    name: 'John Doe',
    id: '12345',
    batchName: 'Batch A',
    course: 'Flutter Development',
    phone: '123-456-7890',
    email: 'john.doe@example.com',
    isConfirmed: true,
    date: DateTime(2023, 10, 26),
  ),
  Inquiry(
    name: 'Jane Smith',
    id: '67890',
    batchName: 'Batch B',
    course: 'UI/UX Design',
    phone: '098-765-4321',
    email: 'jane.smith@example.com',
    isConfirmed: false,
    date: DateTime(2023, 10, 25),
  ),
  Inquiry(
    name: 'Peter Jones',
    id: '11223',
    batchName: 'Batch A',
    course: 'Flutter Development',
    phone: '555-123-4567',
    email: 'peter.jones@example.com',
    isConfirmed: true,
    date: DateTime(2023, 10, 24),
  ),
  Inquiry(
    name: 'Alice Brown',
    id: '44556',
    isConfirmed: false,
    date: DateTime(2023, 10, 23),
  ),
  Inquiry(
    name: 'Bob White',
    id: '77889',
    batchName: 'Batch C',
    course: 'Data Science',
    phone: '222-333-4444',
    email: 'bob.white@example.com',
    isConfirmed: true,
    date: DateTime(2023, 10, 22),
  ),
  Inquiry(
    name: 'Charlie Green',
    id: '99001',
    isConfirmed: false,
    date: DateTime(2023, 10, 21),
  ),
];
