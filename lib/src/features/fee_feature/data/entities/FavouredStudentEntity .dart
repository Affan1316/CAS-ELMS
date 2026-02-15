import 'package:cloud_firestore/cloud_firestore.dart';

// UPDATE your FavouredStudentEntity class with this version

class FavouredStudentEntity {
  final String studentId;
  final String studentName;
  final String groupId;
  final double favouredAmount;
  final double previousTotalFee;
  final double newTotalFee;
  final String description; // NEW: Add description field
  final DateTime createdAt;

  FavouredStudentEntity({
    required this.studentId,
    required this.studentName,
    required this.groupId,
    required this.favouredAmount,
    required this.previousTotalFee,
    required this.newTotalFee,
    required this.description, // NEW
    required this.createdAt,
  });

  factory FavouredStudentEntity.fromMap(Map<String, dynamic> map) {
    return FavouredStudentEntity(
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      groupId: map['groupId'] ?? '',
      favouredAmount: (map['favouredAmount'] as num?)?.toDouble() ?? 0.0,
      previousTotalFee: (map['previousTotalFee'] as num?)?.toDouble() ?? 0.0,
      newTotalFee: (map['newTotalFee'] as num?)?.toDouble() ?? 0.0,
      description:
          map['description'] ?? 'No reason provided', // NEW: Default value
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'groupId': groupId,
      'favouredAmount': favouredAmount,
      'previousTotalFee': previousTotalFee,
      'newTotalFee': newTotalFee,
      'description': description, // NEW
      'createdAt': createdAt,
    };
  }
}
