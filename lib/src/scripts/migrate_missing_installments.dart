import 'package:cloud_firestore/cloud_firestore.dart';

/// Migration Script: Fix Missing Student Installment Documents
///
/// PURPOSE:
/// This script finds students who are enrolled in groups (exist in "{groupName} students" collection)
/// but DON'T have a corresponding document in "student_installment" collection.
///
/// It then creates the missing installment documents so these students appear in Group Report.
///
/// HOW TO RUN:
/// 1. Add this file to your project (e.g., in lib/src/scripts/)
/// 2. Call `migrateMissingInstallments()` from a button in admin panel OR run it once from main()
/// 3. Monitor console logs for progress
/// 4. Verify in Firebase Console that missing documents were created
///
/// WARNING: Run this ONLY ONCE or implement idempotency checks

class InstallmentMigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Main migration function
  /// Set [dryRun] to true to see what would be migrated without actually writing
  Future<MigrationResult> migrateMissingInstallments({
    List<String>? specificGroups,
    bool dryRun = false,
  }) async {
    print('🚀 Starting installment migration...');
    if (dryRun) {
      print('⚠️ DRY RUN MODE - No writes will occur');
    }

    final result = MigrationResult();
    result.startTime = DateTime.now();

    try {
      // Step 1: Get all group names
      List<String> groupNames = specificGroups ?? await _getAllGroupNames();
      print('📋 Found ${groupNames.length} groups to process: $groupNames');

      // Step 2: Process each group
      for (final group in groupNames) {
        try {
          final groupResult = await _migrateGroup(group, dryRun);
          result.totalGroupsProcessed++;
          result.migratedStudents.addAll(groupResult.migratedStudents);
          result.errors.addAll(groupResult.errors);
          print(
            '✅ Group $group: ${groupResult.migratedStudents.length} migrated, ${groupResult.errors.length} errors',
          );
        } catch (e) {
          print('❌ Failed to process group $group: $e');
          result.errors.add('Group $group: $e');
        }
      }

      // Step 3: Summary
      result.endTime = DateTime.now();
      result.duration = result.endTime!.difference(result.startTime!);
      print('');
      print('🎉 Migration Complete!');
      print('   Groups processed: ${result.totalGroupsProcessed}');
      print('   Students migrated: ${result.migratedStudents.length}');
      print('   Errors: ${result.errors.length}');
      print('   Duration: ${result.duration}');
      if (result.migratedStudents.isNotEmpty) {
        print('   Migrated IDs: ${result.migratedStudents.join(", ")}');
      }
      if (result.errors.isNotEmpty) {
        print('   Error details: ${result.errors.join("; ")}');
      }
    } catch (e) {
      print('💥 Migration failed catastrophically: $e');
      result.fatalError = e.toString();
    }

    return result;
  }

  /// Migrate a single group
  Future<GroupMigrationResult> _migrateGroup(String group, bool dryRun) async {
    final result = GroupMigrationResult();

    print('');
    print('📂 Processing group: "$group"');

    // Step 1: Get all enrolled students in this group
    // CRITICAL FIX: Use EXACT group name (case-sensitive) for collection name
    // "A24" → "A24 students", NOT "a24 students"
    print('  🔍 Querying enrolled students from "$group students"...');
    final enrolledSnapshot =
        await _firestore.collection('$group students').get();

    print('  📄 Found ${enrolledSnapshot.docs.length} enrolled students');

    if (enrolledSnapshot.docs.isEmpty) {
      print('  ⚠️ No enrolled students found, skipping');
      return result;
    }

    // Step 2: Get all students with installments in this group
    print('  🔍 Querying existing installments...');
    final installmentSnapshot =
        await _firestore
            .collection('student_installment')
            .where('groupId', isEqualTo: group)
            .get();

    print(
      '  📄 Found ${installmentSnapshot.docs.length} installment documents',
    );

    // Step 3: Find missing students
    final enrolledIds = enrolledSnapshot.docs.map((d) => d.id).toSet();
    final installmentIds = installmentSnapshot.docs.map((d) => d.id).toSet();
    final missingIds = enrolledIds.difference(installmentIds);

    print('  🔍 Missing students: ${missingIds.length}');
    if (missingIds.isNotEmpty) {
      print('  ❌ Missing IDs: ${missingIds.join(", ")}');
    }

    // Step 4: Create missing installment documents
    for (final missingId in missingIds) {
      try {
        final studentDoc = enrolledSnapshot.docs.firstWhere(
          (d) => d.id == missingId,
        );
        final studentData = studentDoc.data();

        if (dryRun) {
          print('  📝 [DRY RUN] Would create installment for: $missingId');
          result.migratedStudents.add(missingId);
          continue;
        }

        // Create the installment document
        final installmentPayload = {
          'id': missingId,
          'name': studentData['name'] ?? 'Unknown',
          'groupId': group,
          'totalFee': 0,
          'paidAmount': 0,
          'numberOfInstallments': 0,
          'amountPerMonth': 0,
          'admissionFee': 0,
          'installments': [],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'migrationNote':
              'Auto-created by migration script on ${DateTime.now().toIso8601String()}',
        };

        await _firestore
            .collection('student_installment')
            .doc(missingId)
            .set(installmentPayload);

        print(
          '  ✅ Created installment for: $missingId (${studentData['name']})',
        );
        result.migratedStudents.add(missingId);
      } catch (e) {
        print('  ❌ Failed to create installment for $missingId: $e');
        result.errors.add('$missingId: $e');
      }
    }

    return result;
  }

  /// Get all group names from Firestore
  Future<List<String>> _getAllGroupNames() async {
    try {
      // Try to get from fee_history_group_wise collection (has all groups with fee activity)
      final snapshot =
          await _firestore.collection('fee_history_group_wise').get();
      return snapshot.docs.map((d) => d.id).toList();
    } catch (e) {
      print('⚠️ Failed to get group names from fee_history_group_wise: $e');
      return [];
    }
  }
}

/// Result of entire migration
class MigrationResult {
  int totalGroupsProcessed = 0;
  final List<String> migratedStudents = [];
  final List<String> errors = [];
  DateTime? startTime;
  DateTime? endTime;
  Duration? duration;
  String? fatalError;
}

/// Result of single group migration
class GroupMigrationResult {
  final List<String> migratedStudents = [];
  final List<String> errors = [];
}

/// STANDALONE FUNCTION for easy execution
/// Call this from anywhere (button, main(), etc.)
Future<MigrationResult> runInstallmentMigration({
  List<String>? groups,
  bool dryRun = false,
}) async {
  final service = InstallmentMigrationService();
  return await service.migrateMissingInstallments(
    specificGroups: groups,
    dryRun: dryRun,
  );
}
