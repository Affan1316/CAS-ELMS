import 'package:cloud_firestore/cloud_firestore.dart';

class InstallmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createInstallmentPlan({
    required String studentId,
    required double totalFee,
    required int numberOfInstallments,
    required double amountPerMonth,
  }) async {
    try {
      await _firestore.collection('student_installment').doc(studentId).set({
        'totalFee': totalFee,
        'numberOfInstallments': numberOfInstallments,
        'amountPerMonth': amountPerMonth,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create installment plan: $e');
    }
  }

  Future<Map<String, dynamic>?> getInstallmentPlan(String studentId) async {
    try {
      final doc =
          await _firestore
              .collection('student_installment')
              .doc(studentId)
              .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get installment plan: $e');
    }
  }
}
