class Attendance {
  final DateTime date;
  final String status;
  final List<Map<String, dynamic>> logs;

  Attendance({required this.date, required this.status, required this.logs});
}