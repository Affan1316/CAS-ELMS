import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../domain/firestore_repositry.dart';
import 'student_entity_class.dart';

class ActualImplementationFirebaseRepo implements FirestoreRepositry {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String completeStudentsCollectionName = "students";
  ActualImplementationFirebaseRepo();
  @override
  addStudentDataToFirebase(StudentEntityClass student) async {
    await addStudentDataAccordingToGroupsToFirebase(student);
    await firestore
        .collection(completeStudentsCollectionName)
        .doc(student.id)
        .set({
          "name": student.name,
          "fatherName": student.fatherName,
          "address": student.address,
          "cnic": student.cnic,
          "gender": student.gender,
          "email": student.email,
          "fatherOccupation": student.fatherOccupation,
          "group": student.group,
          "phone": student.phone,
        });

    // CRITICAL FIX: Auto-create student_installment document
    // This ensures every enrolled student appears in Group Report
    await _createInitialInstallmentDocument(student);
  }

  /// Creates initial installment document for newly enrolled student
  /// This prevents "missing student" issues in Group Report
  Future<void> _createInitialInstallmentDocument(
    StudentEntityClass student,
  ) async {
    try {
      final installmentRef = firestore
          .collection('student_installment')
          .doc(student.id);

      // Check if document already exists (for idempotency)
      final docSnapshot = await installmentRef.get();
      if (docSnapshot.exists) {
        print(
          '✅ Installment document already exists for ${student.id}, skipping creation',
        );
        return;
      }

      // Create initial installment document with placeholder fee data
      final payload = {
        'id': student.id,
        'name': student.name,
        'groupId': student.group,
        'totalFee': 0, // Will be updated when admin creates fee plan
        'paidAmount': 0,
        'numberOfInstallments': 0,
        'amountPerMonth': 0,
        'admissionFee': 0,
        'installments':
            [], // Empty array - will be populated when fee plan is created
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'status':
            'pending_fee_plan', // Flag to indicate fee plan not yet created
      };

      await installmentRef.set(payload);
      print(
        '✅ Created initial installment document for ${student.id} (${student.name})',
      );
    } catch (e) {
      print('⚠️ Failed to create initial installment for ${student.id}: $e');
      // Don't throw - student enrollment should still succeed even if this fails
      // Admin can manually create installment later
    }
  }

  @override
  addStudentDataAccordingToGroupsToFirebase(StudentEntityClass student) async {
    String collectionName = student.group;

    return await firestore
        .collection("$collectionName students")
        .doc(student.id)
        .set({"name": student.name, "rollNum": student.id});
  }

  @override
  Future<Map<String, dynamic>?> readStudentDataBasedOnId(String id) async {
    print("++++++++++++ Being fetched from firebase +++++++");
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection(completeStudentsCollectionName)
            .doc(id)
            .get();

    return documentSnapshot.data();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> readWholeGroupStudentsList(
    String groupTitle,
  ) {
    var a = firestore.collection("$groupTitle students").snapshots();
    return a;
  }

  @override
  Future<List<String>> getGroupsNames() async {
    List<String> list = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      for (var doc in querySnapshot.docs) {
        list.add(doc.id);
      }
    } catch (e) {
      list.add(e.toString());
      print("Error getting documents: $e");
    }
    return list;
  }

  @override
  Future<void> updateStudentGroup({
    required String studentId,
    required String newGroupName,
  }) async {
    try {
      // Step 1: Get current student data to know the old group
      DocumentSnapshot<Map<String, dynamic>> studentDoc =
          await firestore
              .collection(completeStudentsCollectionName)
              .doc(studentId)
              .get();

      if (!studentDoc.exists) {
        throw Exception('Student not found');
      }

      Map<String, dynamic>? studentData = studentDoc.data();
      if (studentData == null) {
        throw Exception('Student data is null');
      }

      String oldGroupName = studentData['group'] ?? '';
      String studentName = studentData['name'] ?? '';

      if (oldGroupName.isEmpty) {
        throw Exception('Student has no current group');
      }

      if (oldGroupName == newGroupName) {
        throw Exception('Student is already in group "$newGroupName"');
      }

      debugPrint(
        '🔄 Transferring student $studentId ($studentName) from "$oldGroupName" to "$newGroupName"',
      );

      // Step 2: Get student's fee data from student_installment (if exists)
      DocumentSnapshot<Map<String, dynamic>> installmentDoc =
          await firestore
              .collection('student_installment')
              .doc(studentId)
              .get();

      double studentTotalFee = 0.0;
      double studentPaidAmount = 0.0;
      bool hasInstallmentDoc = installmentDoc.exists;

      if (hasInstallmentDoc) {
        final installmentData = installmentDoc.data();
        if (installmentData != null) {
          studentTotalFee =
              (installmentData['totalFee'] as num?)?.toDouble() ?? 0.0;
          studentPaidAmount =
              (installmentData['paidAmount'] as num?)?.toDouble() ?? 0.0;

          debugPrint(
            '💰 Student fee data: total=$studentTotalFee, paid=$studentPaidAmount',
          );
        }
      }

      // Step 3: Update the main students collection with new group
      await firestore
          .collection(completeStudentsCollectionName)
          .doc(studentId)
          .update({'group': newGroupName});

      debugPrint('✅ Updated main students collection');

      // Step 4: Remove student from old group collection
      await firestore
          .collection("$oldGroupName students")
          .doc(studentId)
          .delete();

      debugPrint('✅ Removed from "$oldGroupName students"');

      // Step 5: Add student to new group collection
      await firestore.collection("$newGroupName students").doc(studentId).set({
        "name": studentName,
        "rollNum": studentId,
      });

      debugPrint('✅ Added to "$newGroupName students"');

      // Step 6: DO NOT update student_installment.groupId
      // Fee data MUST stay with the ORIGINAL group (oldGroupName)
      // This preserves historical financial accuracy
      if (hasInstallmentDoc) {
        debugPrint(
          '💾 student_installment.groupId remains "$oldGroupName" (fee data stays with original group)',
        );
      }

      // Step 7: NO adjustment to fee_history_group_wise
      // Fee history remains associated with the original group where it was generated
      // This preserves financial integrity - old group keeps their historical records
      debugPrint(
        '💰 Fee history remains with "$oldGroupName" (no transfer of financial data)',
      );

      debugPrint(
        '✅ Student $studentId successfully transferred from "$oldGroupName" to "$newGroupName"',
      );
      debugPrint(
        '📌 Note: Fee data (PKR $studentTotalFee total, PKR $studentPaidAmount paid) remains with "$oldGroupName"',
      );

      // Step 8: Create audit trail for the transfer
      final auditData = {
        'studentId': studentId,
        'studentName': studentName,
        'oldGroupName': oldGroupName,
        'newGroupName': newGroupName,
        'feeTotalRemainingInOldGroup': studentTotalFee,
        'feePaidRemainingInOldGroup': studentPaidAmount,
        'transferredAt': FieldValue.serverTimestamp(),
        'transferredBy': 'admin', // TODO: Get from auth
        'action': 'student_group_transfer',
        'note': 'Fee data preserved in original group ($oldGroupName)',
      };

      await firestore.collection('student_transfer_audit').add(auditData);

      debugPrint('📝 Audit trail created for transfer');
    } catch (e, stackTrace) {
      debugPrint('❌ Error updating student group: $e');
      debugPrint('Stack: $stackTrace');
      throw Exception('Failed to update student group: ${e.toString()}');
    }
  }

  @override
  Future<void> updateStudentData(StudentEntityClass student) async {
    try {
      // Step 1: Get current student data to check if group changed
      DocumentSnapshot<Map<String, dynamic>> studentDoc =
          await firestore
              .collection(completeStudentsCollectionName)
              .doc(student.id)
              .get();

      String? oldGroupName;
      if (studentDoc.exists) {
        Map<String, dynamic>? oldData = studentDoc.data();
        oldGroupName = oldData?['group'];
      }

      // Step 2: Update main student collection
      await firestore
          .collection(completeStudentsCollectionName)
          .doc(student.id)
          .update({
            "name": student.name,
            "fatherName": student.fatherName,
            "address": student.address,
            "cnic": student.cnic,
            "gender": student.gender,
            "email": student.email,
            "fatherOccupation": student.fatherOccupation,
            "group": student.group,
            "phone": student.phone,
          });

      // Step 3: If group changed, update group collections
      if (oldGroupName != null && oldGroupName != student.group) {
        // Remove from old group
        await firestore
            .collection("$oldGroupName students")
            .doc(student.id)
            .delete();

        // Add to new group
        await firestore
            .collection("${student.group} students")
            .doc(student.id)
            .set({"name": student.name, "rollNum": student.id});
      } else {
        // Just update name in current group collection
        await firestore
            .collection("${student.group} students")
            .doc(student.id)
            .update({"name": student.name});
      }

      print("✅ Student ${student.id} updated successfully");
    } catch (e) {
      print("❌ Error updating student data: $e");
      throw Exception('Failed to update student data: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteStudent({
    required String studentId,
    required String groupName,
  }) async {
    try {
      // Step 1: Delete from main students collection
      await firestore
          .collection(completeStudentsCollectionName)
          .doc(studentId)
          .delete();

      // Step 2: Delete from group collection
      await firestore.collection("$groupName students").doc(studentId).delete();

      print("✅ Student $studentId deleted successfully from $groupName");
    } catch (e) {
      print("❌ Error deleting student: $e");
      throw Exception('Failed to delete student: ${e.toString()}');
    }
  }
}
