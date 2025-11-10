// --- MODELS ---
// These classes represent the data structure

/// Represents the attendance status
enum AttendanceStatus { present, absent }

/// Model for a single student
class Student {
  final String name;
  final String rollNo;
  final String imageUrl;

  const Student({
    required this.name,
    required this.rollNo,
    required this.imageUrl,
  });
}


/// Model for a single attendance record
class AttendanceRecord {
  final String date;
  final String day;
  final AttendanceStatus status;

  const AttendanceRecord({
    required this.date,
    required this.day,
    required this.status,
  });
}