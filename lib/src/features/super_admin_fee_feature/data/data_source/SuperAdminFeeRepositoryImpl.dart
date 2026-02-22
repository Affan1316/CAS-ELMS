import 'package:cloud_firestore/cloud_firestore.dart';
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

    // Update student_installment collection
    await _remoteDataSource.runTransaction((transaction) async {
      final docRef = _remoteDataSource
          .collection(_collectionPath2)
          .doc(studentId);
      final snapshot = await transaction.get(docRef);

      _validateSnapshot(snapshot, studentId, _collectionPath2);

      final data = snapshot.data()!;
      final installments = _extractInstallments(data);
      final result = _processInstallments(installments, installmentId);

      _updateGroupWisePaymentHistory(
        data["groupId"],
        _currentInstallment["paidAmount"],
      );

      if (!result.updated) {
        throw Exception(
          'Installment with ID $installmentId not found for student $studentId',
        );
      }

      transaction.update(docRef, {
        'installments': result.installments,
        'paidAmount': result.totalPaidAmount,
      });

      print(
        'Payment confirmed in $_collectionPath2 for installment $installmentId',
      );
    });

    // Update not_approved_fee_installments collection and collect payment history data
    await _remoteDataSource.runTransaction((transaction) async {
      final docRef = _remoteDataSource
          .collection(_collectionPath1)
          .doc(studentId);
      final snapshot = await transaction.get(docRef);

      _validateSnapshot(snapshot, studentId, _collectionPath1);

      final data = snapshot.data()!;
      final installments = _extractInstallments(data);
      final result = _processInstallments(installments, installmentId);

      if (!result.updated) {
        throw Exception(
          'Installment with ID $installmentId not found for student $studentId',
        );
      }

      final updatedInstallment = result.installments.firstWhere(
        (inst) => inst['id'] == installmentId,
      );

      // Use paidDate from installment as createdAt, fallback to serverTimestamp if null
      final String? paidDateStr = updatedInstallment['paidDate'];
      final createdAt =
          paidDateStr != null
              ? Timestamp.fromDate(DateTime.parse(paidDateStr))
              : FieldValue.serverTimestamp();

      paymentHistoryData = {
        'paidAmount':
            (updatedInstallment['paidAmount'] as num?)?.toDouble() ?? 0.0,
        'paymentMethod': updatedInstallment['paymentMethod'] ?? 'Unknown',
        'createdAt': createdAt,
        'name': data['name'] ?? 'Unknown',
        'rollnumber': data['id'] ?? 'Unknown',
        'installmentId': installmentId,
        'studentId': studentId,
      };

      transaction.update(docRef, {
        'installments': result.installments,
        'paidAmount': result.totalPaidAmount,
      });

      print(
        'Payment confirmed in $_collectionPath1 for installment $installmentId',
      );
    });

    return paymentHistoryData;
  }

  /// Writes payment history to fee_history_daywise collection
  Future<void> _writePaymentHistory(Map<String, dynamic> paymentData) async {
    try {
      final historyRef =
          _remoteDataSource.collection('fee_history_daywise').doc();
      await historyRef.set(paymentData);
      print('Payment history logged successfully');
    } catch (e) {
      // Log error but don't fail the entire operation since payment is already confirmed
      print('Warning: Failed to log payment history: $e');
    }
  }

  /// Update Group Wise Fee History
  Future<void> _updateGroupWisePaymentHistory(
    String groupId,
    double paymentAmount,
  ) async {
    var docref = _remoteDataSource
        .collection('fee_history_group_wise')
        .doc(groupId);

    DocumentSnapshot<Map<String, dynamic>> snapshot = await docref.get();

    if (!snapshot.exists) {
      docref.set({"received": paymentAmount});
    } else {
      Map<String, dynamic>? snapshotData = snapshot.data();
      if (snapshotData != null) {
        paymentAmount = paymentAmount + snapshotData["received"];
        Map<String, dynamic> updatedMap = {"received": paymentAmount};
        await docref.update(updatedMap);
      } else {
        throw ("Assertion error snapshot data did not found");
      }
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
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _remoteDataSource.collection(_collectionPath3).doc(groupId).get();
    Map<String, dynamic>? mapData = documentSnapshot.data();
    if (mapData != null) {
      return GroupFeeHistory.fromMap(mapData);
    } else {
      return "No Fee History";
    }
  }
}
