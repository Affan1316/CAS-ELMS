import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/group_fee_history.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/data/entity/installment_process_result.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/abstract_repo/super_admin_fee_repository.dart';

class SuperAdminFeeRepositoryImpl implements SuperAdminFeeRepository {
  final FirebaseFirestore _remoteDataSource;
  static const String _collectionPath1 = "not_approved_fee_installments";
  static const String _collectionPath2 = "student_installment";
  static const String _collectionPath3 = "fee_history_group_wise";

  late Map<String, dynamic> _currentInstallment;

  SuperAdminFeeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Map<String, dynamic>>> getNotifications() async {
    var a = await _remoteDataSource.collection(_collectionPath1).get();
    var b = a.docs;
    List<Map<String, dynamic>> c = [];
    for (var element in b) {
      c.add(element.data());
    }
    return c;
  }

  @override
  Future<void> confirmPayment(String id, String studentId) async {
    // Validate inputs
    if (id.isEmpty || studentId.isEmpty) {
      throw ArgumentError('Payment ID and Student ID cannot be empty');
    }

    try {
      // Step 1: Update both collections and collect payment history data
      final paymentHistoryData = await _updateCollectionsAndGetHistoryData(
        id,
        studentId,
      );

      // Step 2: Write payment history outside transaction for better performance
      if (paymentHistoryData != null) {
        await _writePaymentHistory(paymentHistoryData);
      }
    } catch (e) {
      // Log error and rethrow with context
      print(
        'Error confirming payment for installment $id of student $studentId: $e',
      );
      rethrow;
    }
  }

  @override
  Future<void> confirmBulkPayments(List<Map<String, String>> payments) async {
    if (payments.isEmpty) {
      throw ArgumentError('Payment list cannot be empty');
    }

    List<String> errors = [];
    List<Map<String, dynamic>> successfulPaymentHistories = [];

    // Process each payment
    for (var payment in payments) {
      try {
        final id = payment['id']!;
        final studentId = payment['studentId']!;

        // Update collections and get payment history data
        final paymentHistoryData = await _updateCollectionsAndGetHistoryData(
          id,
          studentId,
        );

        if (paymentHistoryData != null) {
          successfulPaymentHistories.add(paymentHistoryData);
        }
      } catch (e) {
        errors.add(
          'Failed to confirm payment ${payment['id']} for student ${payment['studentId']}: $e',
        );
      }
    }

    // Write all successful payment histories
    for (var historyData in successfulPaymentHistories) {
      try {
        await _writePaymentHistory(historyData);
      } catch (e) {
        print('Warning: Failed to log payment history: $e');
      }
    }

    // If there were any errors, report them
    if (errors.isNotEmpty) {
      throw Exception('Some payments failed:\n${errors.join('\n')}');
    }
  }

  /// Updates both collections and returns payment history data
  ///
  /// Returns payment history data if found, null otherwise
  Future<Map<String, dynamic>?> _updateCollectionsAndGetHistoryData(
    String installmentId,
    String studentId,
  ) async {
    Map<String, dynamic>? paymentHistoryData;
    String? groupId;
    double? paidAmount;

    // ✅ Transaction 1: Update student_installment
    await _remoteDataSource.runTransaction((transaction) async {
      final docRef = _remoteDataSource
          .collection(_collectionPath2)
          .doc(studentId);
      final snapshot = await transaction.get(docRef);

      _validateSnapshot(snapshot, studentId, _collectionPath2);

      final data = snapshot.data()!;
      final installments = _extractInstallments(data);

      // ✅ Use local variable, not shared instance variable
      Map<String, dynamic>? matchedInstallment;
      double totalPaidAmount = 0.0;
      bool updated = false;

      for (final inst in installments) {
        final amount = (inst['paidAmount'] as num?)?.toDouble() ?? 0.0;
        totalPaidAmount += amount;
        if (inst['id'] == installmentId) {
          inst['status'] = 'Paid';
          updated = true;
          matchedInstallment = inst;
        }
      }

      if (!updated || matchedInstallment == null) {
        throw Exception(
          'Installment $installmentId not found for student $studentId',
        );
      }

      // ✅ Capture values LOCALLY before transaction ends
      groupId = data["groupId"] as String?;
      paidAmount =
          (matchedInstallment['paidAmount'] as num?)?.toDouble() ?? 0.0;

      transaction.update(docRef, {
        'installments': installments,
        'paidAmount': totalPaidAmount,
      });
    });

    // ✅ Transaction 2: Update not_approved_fee_installments
    await _remoteDataSource.runTransaction((transaction) async {
      final docRef = _remoteDataSource
          .collection(_collectionPath1)
          .doc(studentId);
      final snapshot = await transaction.get(docRef);

      _validateSnapshot(snapshot, studentId, _collectionPath1);

      final data = snapshot.data()!;
      final installments = _extractInstallments(data);

      double totalPaidAmount = 0.0;
      bool updated = false;
      Map<String, dynamic>? updatedInstallment;

      for (final inst in installments) {
        totalPaidAmount += (inst['paidAmount'] as num?)?.toDouble() ?? 0.0;
        if (inst['id'] == installmentId) {
          inst['status'] = 'Paid';
          updated = true;
          updatedInstallment = inst;
        }
      }

      if (!updated || updatedInstallment == null) {
        throw Exception(
          'Installment $installmentId not found in pending collection',
        );
      }

      final String? paidDateStr = updatedInstallment['paidDate'];
      final paidDate =
          paidDateStr != null
              ? Timestamp.fromDate(DateTime.parse(paidDateStr).toUtc())
              : Timestamp.now();

      paymentHistoryData = {
        'paidAmount':
            (updatedInstallment['paidAmount'] as num?)?.toDouble() ?? 0.0,
        'paymentMethod': updatedInstallment['paymentMethod'] ?? 'Unknown',
        'createdAt': paidDate,
        'paidDate': paidDate,
        'approvedAt': FieldValue.serverTimestamp(),
        'name': data['name'] ?? 'Unknown',
        'rollnumber': data['id'] ?? 'Unknown',
        'installmentId': installmentId,
        'studentId': studentId,
      };

      transaction.update(docRef, {
        'installments': installments,
        'paidAmount': totalPaidAmount,
      });
    });

    // ✅ Now OUTSIDE transaction — safe Firestore call, properly awaited
    if (groupId != null && paidAmount != null) {
      await _updateGroupWisePaymentHistory(groupId!, paidAmount!);
    }

    return paymentHistoryData;
  }

  /// Writes payment history to fee_history_daywise collection.
  /// Includes dedup protection — skips write if installmentId already exists.
  Future<void> _writePaymentHistory(Map<String, dynamic> paymentData) async {
    try {
      debugPrint('💾 Attempting to write payment history...');
      debugPrint('💾 Data: $paymentData');

      // Dedup check: skip if this installmentId already has a history record
      final instId = paymentData['installmentId'] as String?;
      if (instId != null) {
        final existing =
            await _remoteDataSource
                .collection('fee_history_daywise')
                .where('installmentId', isEqualTo: instId)
                .limit(1)
                .get();
        if (existing.docs.isNotEmpty) {
          debugPrint(
            '⚠️ History record already exists for installmentId: $instId — skipping duplicate write',
          );
          return;
        }
      }

      final historyRef =
          _remoteDataSource.collection('fee_history_daywise').doc();
      await historyRef.set(paymentData);

      debugPrint('✅ Payment history written! Doc ID: ${historyRef.id}');
    } catch (e, stack) {
      debugPrint('❌ _writePaymentHistory FAILED: $e');
      debugPrint('📍 Stack: $stack');
      rethrow;
    }
  }

  Future<void> _updateGroupWisePaymentHistory(
    String groupId,
    double paymentAmount,
  ) async {
    debugPrint('✍️ Updating fee history for groupId: "$groupId" with increment: $paymentAmount');
    final docRef = _remoteDataSource
        .collection('fee_history_group_wise')
        .doc(groupId);

    try {
      await docRef.set({
        "received": FieldValue.increment(paymentAmount)
      }, SetOptions(merge: true));
      debugPrint('✅ Group-wise fee history updated for "$groupId"');
    } catch (e) {
      debugPrint('❌ Failed to update group-wise fee history: $e');
      rethrow;
    }
  }

  /// Validates document snapshot exists and has data
  void _validateSnapshot(
    DocumentSnapshot snapshot,
    String studentId,
    String collectionPath,
  ) {
    if (!snapshot.exists) {
      throw Exception(
        'Student document not found for ID: $studentId in $collectionPath',
      );
    }

    if (snapshot.data() == null) {
      throw Exception('Document data is null for student: $studentId');
    }
  }

  /// Extracts installments from document data with validation
  List<Map<String, dynamic>> _extractInstallments(Map<String, dynamic> data) {
    if (!data.containsKey('installments')) {
      throw Exception('Installments field is missing');
    }

    final installmentsData = data['installments'];
    if (installmentsData == null) {
      throw Exception('Installments field is null');
    }

    if (installmentsData is! List) {
      throw Exception('Installments field is not a List');
    }

    return installmentsData
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  /// Processes installments to update payment status and calculate totals
  InstallmentProcessResult _processInstallments(
    List<Map<String, dynamic>> installments,
    String installmentId,
  ) {
    double totalPaidAmount = 0.0;
    bool updated = false;

    for (final installment in installments) {
      final paidAmount = (installment['paidAmount'] as num?)?.toDouble() ?? 0.0;
      totalPaidAmount += paidAmount;

      if (installment['id'] == installmentId) {
        installment['status'] = 'Paid';
        updated = true;
        _currentInstallment = installment;
      }
    }

    return InstallmentProcessResult(
      installments: installments,
      totalPaidAmount: totalPaidAmount,
      updated: updated,
    );
  }

  @override
  Future fetchGroupFeeHistory(String groupId) async {
    debugPrint('📊 Aggregating installment data for group: "$groupId"');

    try {
      // Query all students belonging to this group from the installment table
      // (single source of truth as per admin installment system)
      debugPrint('🔍 Querying student_installment where groupId == "$groupId"');

      final querySnapshot =
          await _remoteDataSource
              .collection(_collectionPath2) // student_installment
              .where('groupId', isEqualTo: groupId)
              .get();

      debugPrint(
        '📄 Query returned ${querySnapshot.docs.length} documents from Firestore',
      );

      if (querySnapshot.docs.isEmpty) {
        debugPrint(
          '⚠️ No students found in student_installment for group: "$groupId"',
        );
        return "No Fee History";
      }

      double totalFeeSum = 0.0;
      double receivedSum = 0.0;
      int studentsProcessed = 0;
      int studentsSkipped = 0;
      List<String> skippedStudentIds = [];
      List<String> errorMessages = [];

      for (final doc in querySnapshot.docs) {
        try {
          // Skip group configuration document (same ID as group name)
          // Real students have IDs like "a24-1", "a24-2", etc.
          if (doc.id.toLowerCase() == groupId.toLowerCase()) {
            debugPrint('  ⏭️ Skipping group config doc: ${doc.id}');
            studentsSkipped++;
            continue;
          }

          final data = doc.data();

          // Validate document has required fields
          if (data.isEmpty) {
            debugPrint(
              '  ⚠️ Student ${doc.id}: Document data is empty, skipping',
            );
            studentsSkipped++;
            skippedStudentIds.add(doc.id);
            errorMessages.add('${doc.id}: empty data');
            continue;
          }

          // Use document-level totalFee (set correctly at creation)
          if (!data.containsKey('totalFee')) {
            debugPrint(
              '  ⚠️ Student ${doc.id}: Missing totalFee field, using 0',
            );
          }
          final totalFee = (data['totalFee'] as num?)?.toDouble() ?? 0.0;
          totalFeeSum += totalFee;

          // Sum paidAmount from ALL installments — matching admin card logic
          // This includes Paid, pending, and skipped (skipped has paidAmount=0)
          // The admin installment page shows: Received = sum of all paidAmounts
          final installments = data['installments'] as List<dynamic>?;

          if (installments == null) {
            debugPrint(
              '  ⚠️ Student ${doc.id}: Missing installments field, received=0',
            );
          }

          double studentReceived = 0.0;
          if (installments != null) {
            for (final inst in installments) {
              try {
                final instMap = inst as Map<String, dynamic>;
                final paid = (instMap['paidAmount'] as num?)?.toDouble() ?? 0.0;
                studentReceived += paid;
              } catch (e) {
                debugPrint(
                  '  ⚠️ Student ${doc.id}: Error parsing installment: $e',
                );
              }
            }
          }

          receivedSum += studentReceived;
          studentsProcessed++;

          debugPrint(
            '  ✅ Student ${doc.id}: total=$totalFee, '
            'received=$studentReceived, '
            'remaining=${totalFee - studentReceived}',
          );
        } catch (e) {
          debugPrint('  ❌ Error processing student ${doc.id}: $e');
          studentsSkipped++;
          skippedStudentIds.add(doc.id);
          errorMessages.add('${doc.id}: $e');
        }
      }

      final remaining = totalFeeSum - receivedSum;

      debugPrint('📊 Group "$groupId" SUMMARY:');
      debugPrint(
        '   📥 Total documents from query: ${querySnapshot.docs.length}',
      );
      debugPrint('   ✅ Students processed: $studentsProcessed');
      debugPrint('   ⏭️ Students skipped: $studentsSkipped');
      if (skippedStudentIds.isNotEmpty) {
        debugPrint('   ❌ Skipped IDs: ${skippedStudentIds.join(", ")}');
      }
      if (errorMessages.isNotEmpty) {
        debugPrint('   ⚠️ Errors: ${errorMessages.join("; ")}');
      }
      debugPrint(
        '   💰 Total: $totalFeeSum | Received: $receivedSum | Remaining: $remaining',
      );

      // Return error if no students were successfully processed
      if (studentsProcessed == 0) {
        return "Error: No valid student records found for group '$groupId'";
      }

      return GroupFeeHistory(
        total: totalFeeSum,
        received: receivedSum,
        remaining: remaining,
      );
    } on FirebaseException catch (e, stackTrace) {
      debugPrint('❌ FirebaseException in fetchGroupFeeHistory: ${e.code}');
      debugPrint('   Message: ${e.message}');
      debugPrint('   Stack: $stackTrace');
      return "Firebase Error: ${e.message ?? e.code}";
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error in fetchGroupFeeHistory: $e');
      debugPrint('   Stack: $stackTrace');
      return "Error: $e";
    }
  }
}
