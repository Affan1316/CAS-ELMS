
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/repository/fee_cleanup_repository.dart';

class FeeCleanupRepositoryImpl implements FeeCleanupRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> deleteStudentFeeData({
    required String studentId,
    required String groupId,
  }) async {
    try {
      print("[FeeCleanup] Starting fee cleanup for Student: $studentId, Group: $groupId");

      // 1. Get student's total fee and paid amount from student_installment collection BEFORE deleting it
      double? studentTotalFee;
      double? studentPaidAmount;
      try {
        final studentInstallmentDoc = await _firestore
            .collection('student_installment')
            .doc(studentId)
            .get();
        
        if (studentInstallmentDoc.exists && studentInstallmentDoc.data() != null) {
          final data = studentInstallmentDoc.data()!;
          studentTotalFee = (data['totalFee'] as num?)?.toDouble();
          studentPaidAmount = (data['paidAmount'] as num?)?.toDouble();
          print("[FeeCleanup] Found valid student fee data: Total=$studentTotalFee, Paid=$studentPaidAmount");
        }
      } catch (e) {
        print("[FeeCleanup] Error fetching student installment data: $e");
      }

      // 2. Delete from student_installment collection
      await _firestore.collection('student_installment').doc(studentId).delete();
      print("[FeeCleanup] Deleted from student_installment");

      // 3. Update fee_history_group_wise (Subtract student's fee from total and paid amount from received)
      if ((studentTotalFee != null && studentTotalFee > 0) || (studentPaidAmount != null && studentPaidAmount > 0)) {
        final groupHistoryRef = _firestore.collection('fee_history_group_wise').doc(groupId);
        
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(groupHistoryRef);
          
          if (snapshot.exists && snapshot.data() != null) {
            final double currentTotal = (snapshot.data()!['total'] as num?)?.toDouble() ?? 0.0;
            final double currentReceived = (snapshot.data()!['received'] as num?)?.toDouble() ?? 0.0;
            
            final double newTotal = currentTotal - (studentTotalFee ?? 0.0);
            final double newReceived = currentReceived - (studentPaidAmount ?? 0.0);
            
            transaction.update(groupHistoryRef, {
              'total': newTotal,
              'received': newReceived,
            });
            print("[FeeCleanup] Updated group history. Total: $currentTotal->$newTotal, Received: $currentReceived->$newReceived");
          }
        });
      }

      // 4. Update fee_defaulters_collective_data 
      // We must read the defaulter record first to get the remaining fee BEFORE deleting it
       try {
        final defaulterDoc = await _firestore
            .collection("$groupId defaulter students")
            .doc(studentId)
            .get();

        if (defaulterDoc.exists && defaulterDoc.data() != null) {
           final double studentRemainingFee = (defaulterDoc.data()!['remaingFee'] as num?)?.toDouble() ?? 0.0;
           
           if (studentRemainingFee > 0) {
             final collectiveRef = _firestore.collection("fee_defaulters_collective_data").doc(groupId);
             
              await _firestore.runTransaction((transaction) async {
                final snapshot = await transaction.get(collectiveRef);
                if (snapshot.exists && snapshot.data() != null) {
                  final double currentCollectiveRemaining = (snapshot.data()!['remaingFee'] as num?)?.toDouble() ?? 0.0;
                  final double currentTotal = (snapshot.data()!['total'] as num?)?.toDouble() ?? 0.0;
                  
                  final newCollectiveRemaining = currentCollectiveRemaining - studentRemainingFee;
                  final newTotal = currentTotal - 1;
                  
                  if (newTotal <= 0) {
                     transaction.delete(collectiveRef);
                      print("[FeeCleanup] Deleted collective defaulter record as total is 0");
                  } else {
                     transaction.update(collectiveRef, {
                       'remaingFee': newCollectiveRemaining,
                       'total': newTotal
                     });
                      print("[FeeCleanup] Updated collective defaulter. Remaining: $newCollectiveRemaining");
                  }
                }
              });
           }
        }
      } catch (e) {
         print("[FeeCleanup] Error updating collective defaulter data: $e");
      }

      // 5. Delete from [Group] defaulfer students
      await _firestore
          .collection("$groupId defaulter students")
          .doc(studentId)
          .delete();
      print("[FeeCleanup] Deleted from $groupId defaulter students");


      // 6. Delete from not_approved_fee_installments
      await _firestore
          .collection("not_approved_fee_installments")
          .doc(studentId)
          .delete();
      print("[FeeCleanup] Deleted from not_approved_fee_installments");

      // 7. Delete from fee_favours
      await _firestore.collection('fee_favours').doc(studentId).delete();
      print("[FeeCleanup] Deleted from fee_favours");

      print("[FeeCleanup] Completed fee cleanup for Student: $studentId");

    } catch (e) {
      print("[FeeCleanup] Global error during fee cleanup: $e");
      // We don't rethrow because we don't want to block student deletion if fee cleanup fails partial
    }
  }
}
