// shared/enums.dart
import 'package:flutter/material.dart';

// Status enum for UI consistency
enum LeaveStatus { pending, approved, rejected }

// Helper class for LeaveStatus operations
class LeaveStatusHelper {
  // Convert string status to enum
  static LeaveStatus stringToLeaveStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return LeaveStatus.approved;
      case 'rejected':
      case 'declined':
        return LeaveStatus.rejected;
      case 'pending':
      default:
        return LeaveStatus.pending;
    }
  }

  // Convert enum status to Firebase string
  static String leaveStatusToFirebaseString(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.approved:
        return 'approved';
      case LeaveStatus.rejected:
        return 'declined';
      case LeaveStatus.pending:
        return 'pending';
    }
  }

  // Convert enum status to display string
  static String leaveStatusToDisplayString(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.pending:
        return "Pending";
      case LeaveStatus.approved:
        return "Approved";
      case LeaveStatus.rejected:
        return "Rejected";
    }
  }

  // Get status color for UI
  static Color getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.rejected:
        return Colors.red;
      case LeaveStatus.pending:
        return Colors.orange;
    }
  }

  // Get status text (alias for display string)
  static String getStatusText(LeaveStatus status) {
    return leaveStatusToDisplayString(status);
  }
}

// Helper class for general utilities
class UIHelper {
  // Get initials from name
  static String getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '';
  }

  // Parse date strings to DateTime
  static DateTime parseDate(String dateString) {
    try {
      // Try parsing different date formats
      if (dateString.contains('/')) {
        final parts = dateString.split('/');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      } else if (dateString.contains('-')) {
        return DateTime.parse(dateString);
      }
      // Fallback to current date if parsing fails
      return DateTime.now();
    } catch (e) {
      return DateTime.now();
    }
  }

  // Format date to display string (dd/mm/yyyy)
  static String formatDateToDisplay(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Format date from string to display string
  static String formatDateStringToDisplay(String dateString) {
    final date = parseDate(dateString);
    return formatDateToDisplay(date);
  }
}