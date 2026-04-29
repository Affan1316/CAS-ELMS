import 'package:cloud_firestore/cloud_firestore.dart';

/// Validation Service: Find Students Missing Fee Plans
///
/// PURPOSE:
/// This service helps admins identify students who:
/// 1. Are enrolled in a group (exist in "{groupName} students")
/// 2. Have a student_installment document
/// 3. But have NOT created a fee plan yet (status == 'pending_fee_plan' OR empty installments)
///
/// This is useful for:
/// - Admin dashboard showing "X students need fee plans"
/// - Warning badges on Group Report
/// - Reminder notifications to admins

class FeePlanValidationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Find all students in a group who are missing fee plans
  Future<List<StudentFeeStatus>> getStudentsMissingFeePlans(
    String groupId,
  ) async {
    try {
      // Get all students with installments in this group
      final installmentSnapshot =
          await _firestore
              .collection('student_installment')
              .where('groupId', isEqualTo: groupId)
              .get();

      final studentsWithFeePlans = <StudentFeeStatus>[];
      final studentsMissingFeePlans = <StudentFeeStatus>[];

      for (final doc in installmentSnapshot.docs) {
        final data = doc.data();
        final installments = data['installments'] as List<dynamic>? ?? [];
        final status = data['status'] as String?;

        final studentStatus = StudentFeeStatus(
          studentId: doc.id,
          name: data['name'] as String? ?? 'Unknown',
          groupId: groupId,
          hasFeePlan: installments.isNotEmpty && status != 'pending_fee_plan',
          totalFee: (data['totalFee'] as num?)?.toDouble() ?? 0.0,
          paidAmount: (data['paidAmount'] as num?)?.toDouble() ?? 0.0,
          installmentCount: installments.length,
        );

        if (studentStatus.hasFeePlan) {
          studentsWithFeePlans.add(studentStatus);
        } else {
          studentsMissingFeePlans.add(studentStatus);
        }
      }

      return studentsMissingFeePlans;
    } catch (e) {
      print('❌ Error getting students missing fee plans: $e');
      return [];
    }
  }

  /// Get summary statistics for a group
  Future<GroupFeeValidationSummary> getGroupValidationSummary(
    String groupId,
  ) async {
    try {
      // Get enrolled students count (from "{groupName} students" collection)
      // CRITICAL: Use EXACT group name (case-sensitive)
      final enrolledSnapshot =
          await _firestore.collection('$groupId students').get();

      final totalEnrolled = enrolledSnapshot.docs.length;

      // Get students with installment documents
      final installmentSnapshot =
          await _firestore
              .collection('student_installment')
              .where('groupId', isEqualTo: groupId)
              .get();

      final hasInstallmentDoc = installmentSnapshot.docs.length;

      // Count students with actual fee plans
      int withFeePlans = 0;
      int pendingFeePlans = 0;
      double totalFees = 0.0;
      double totalReceived = 0.0;

      for (final doc in installmentSnapshot.docs) {
        final data = doc.data();
        final installments = data['installments'] as List<dynamic>? ?? [];
        final status = data['status'] as String?;

        if (installments.isNotEmpty && status != 'pending_fee_plan') {
          withFeePlans++;
        } else {
          pendingFeePlans++;
        }

        totalFees += (data['totalFee'] as num?)?.toDouble() ?? 0.0;
        totalReceived += (data['paidAmount'] as num?)?.toDouble() ?? 0.0;
      }

      return GroupFeeValidationSummary(
        groupId: groupId,
        totalEnrolled: totalEnrolled,
        hasInstallmentDoc: hasInstallmentDoc,
        withFeePlans: withFeePlans,
        pendingFeePlans: pendingFeePlans,
        totalFees: totalFees,
        totalReceived: totalReceived,
        remainingBalance: totalFees - totalReceived,
        hasDiscrepancies: totalEnrolled != hasInstallmentDoc,
      );
    } catch (e) {
      print('❌ Error getting group validation summary: $e');
      return GroupFeeValidationSummary(
        groupId: groupId,
        totalEnrolled: 0,
        hasInstallmentDoc: 0,
        withFeePlans: 0,
        pendingFeePlans: 0,
        totalFees: 0.0,
        totalReceived: 0.0,
        remainingBalance: 0.0,
        hasDiscrepancies: true,
        error: e.toString(),
      );
    }
  }

  /// Check ALL groups for discrepancies
  Future<List<GroupFeeValidationSummary>> validateAllGroups() async {
    try {
      // Get all group names from fee_history_group_wise
      final groupsSnapshot =
          await _firestore.collection('fee_history_group_wise').get();

      final summaries = <GroupFeeValidationSummary>[];

      for (final groupDoc in groupsSnapshot.docs) {
        final groupId = groupDoc.id;
        final summary = await getGroupValidationSummary(groupId);
        summaries.add(summary);
      }

      return summaries;
    } catch (e) {
      print('❌ Error validating all groups: $e');
      return [];
    }
  }
}

/// Status of a single student's fee plan
class StudentFeeStatus {
  final String studentId;
  final String name;
  final String groupId;
  final bool hasFeePlan;
  final double totalFee;
  final double paidAmount;
  final int installmentCount;

  StudentFeeStatus({
    required this.studentId,
    required this.name,
    required this.groupId,
    required this.hasFeePlan,
    required this.totalFee,
    required this.paidAmount,
    required this.installmentCount,
  });

  double get remainingBalance => totalFee - paidAmount;

  @override
  String toString() {
    return 'StudentFeeStatus('
        'id: $studentId, '
        'name: $name, '
        'hasFeePlan: $hasFeePlan, '
        'installments: $installmentCount'
        ')';
  }
}

/// Summary of validation for a group
class GroupFeeValidationSummary {
  final String groupId;
  final int totalEnrolled;
  final int hasInstallmentDoc;
  final int withFeePlans;
  final int pendingFeePlans;
  final double totalFees;
  final double totalReceived;
  final double remainingBalance;
  final bool hasDiscrepancies;
  final String? error;

  GroupFeeValidationSummary({
    required this.groupId,
    required this.totalEnrolled,
    required this.hasInstallmentDoc,
    required this.withFeePlans,
    required this.pendingFeePlans,
    required this.totalFees,
    required this.totalReceived,
    required this.remainingBalance,
    required this.hasDiscrepancies,
    this.error,
  });

  int get missingInstallmentDocs => totalEnrolled - hasInstallmentDoc;

  @override
  String toString() {
    return 'GroupFeeValidationSummary('
        'group: $groupId, '
        'enrolled: $totalEnrolled, '
        'withInstallment: $hasInstallmentDoc, '
        'withFeePlans: $withFeePlans, '
        'pending: $pendingFeePlans, '
        'discrepancies: $hasDiscrepancies'
        ')';
  }
}
