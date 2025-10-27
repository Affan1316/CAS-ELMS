import 'dart:convert';

class Leave {
  final String id;
  final String studentName;
  final String section;
  final String status;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String reason;
  final String currentDate;
  Leave({
    required this.id,
    required this.studentName,
    required this.section,
    required this.status,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.currentDate,
  });

  Leave copyWith({
    String? id,
    String? studentName,
    String? section,
    String? status,
    String? leaveType,
    String? fromDate,
    String? toDate,
    String? reason,
    String? currentDate,
  }) {
    return Leave(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      section: section ?? this.section,
      status: status ?? this.status,
      leaveType: leaveType ?? this.leaveType,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      reason: reason ?? this.reason,
      currentDate: currentDate ?? this.currentDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentName': studentName,
      'section': section,
      'status': status,
      'leaveType': leaveType,
      'fromDate': fromDate,
      'toDate': toDate,
      'reason': reason,
      'currentDate': currentDate,
    };
  }

  factory Leave.fromMap(Map<String, dynamic> map) {
    return Leave(
      id: map['id'] ?? '',
      studentName: map['studentName'] ?? '',
      section: map['section'] ?? '',
      status: map['status'] ?? '',
      leaveType: map['leaveType'] ?? '',
      fromDate: map['fromDate'] ?? '',
      toDate: map['toDate'] ?? '',
      reason: map['reason'] ?? '',
      currentDate: map['currentDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Leave.fromJson(String source) => Leave.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Leave(id: $id, studentName: $studentName, section: $section, status: $status, leaveType: $leaveType, fromDate: $fromDate, toDate: $toDate, reason: $reason, currentDate: $currentDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Leave &&
        other.id == id &&
        other.studentName == studentName &&
        other.section == section &&
        other.status == status &&
        other.leaveType == leaveType &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.reason == reason &&
        other.currentDate == currentDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentName.hashCode ^
        section.hashCode ^
        status.hashCode ^
        leaveType.hashCode ^
        fromDate.hashCode ^
        toDate.hashCode ^
        reason.hashCode ^
        currentDate.hashCode;
  }
}
