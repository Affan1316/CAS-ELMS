// import 'package:cloud_firestore/cloud_firestore.dart';

// class InstallmentService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> createInstallmentPlan({
//     required String studentId,
//     required double totalFee,
//     required int numberOfInstallments,
//     required double amountPerMonth,
//   }) async {
//     try {
//       await _firestore.collection('student_installment').doc(studentId).set({
//         'totalFee': totalFee,
//         'numberOfInstallments': numberOfInstallments,
//         'amountPerMonth': amountPerMonth,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       throw Exception('Failed to create installment plan: $e');
//     }
//   }

//   Future<Map<String, dynamic>?> getInstallmentPlan(String studentId) async {
//     try {
//       final doc =
//           await _firestore
//               .collection('student_installment')
//               .doc(studentId)
//               .get();

//       if (doc.exists) {
//         return doc.data();
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to get installment plan: $e');
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/installment_page/presentation/fee_installment.dart';
import 'package:uuid/uuid.dart';

class InstallmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  /// Creates / replaces the document in student_installment/{studentId}
  Future<void> createStudentWithInstallments({
    required String studentId,
    required String name,
    required String groupId,
    required double totalFee,
    required int numberOfInstallments,
  }) async {
    try {
      final double amountPerMonth = totalFee / numberOfInstallments;

      final List<Map<String, dynamic>> installments = List.generate(
        numberOfInstallments,
        (i) {
          final dueDate = DateTime.now().add(Duration(days: 30 * (i + 1)));
          final FeeInstallment inst = FeeInstallment(
            id: _uuid.v4(),
            title: 'Installment ${i + 1}',
            totalAmount: amountPerMonth,
            paidAmount: 0,
            dueDate: dueDate,
            paidDate: null,
            paymentMethod: null,
          );
          return inst.toMap();
        },
      );

      final Map<String, dynamic> payload = {
        'id': studentId,
        'name': name,
        'groupId': groupId,
        'totalFee': totalFee, // ✅ totalFee added
        'numberOfInstallments': numberOfInstallments,
        'amountPerMonth': amountPerMonth,
        'installments': installments,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('student_installment')
          .doc(studentId)
          .set(payload, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to create installment plan: $e');
    }
  }

  /// Fetch a student document
  Future<StudentFeeFeature?> getStudent(String studentId) async {
    try {
      final doc =
          await _firestore
              .collection('student_installment')
              .doc(studentId)
              .get();

      if (!doc.exists) return null;
      final data = doc.data()!;

      final Map<String, dynamic> normalized = {
        'id': data['id'] ?? studentId,
        'name': data['name'] ?? '',
        'groupId': data['groupId'] ?? '',
        'totalFee': data['totalFee'] ?? 0, // ✅ also normalize totalFee
        'installments':
            (data['installments'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList(),
      };

      return StudentFeeFeature.fromMap(normalized);
    } catch (e) {
      throw Exception('Failed to fetch installment plan: $e');
    }
  }

  /// Update a specific installment (mark paid / update fields)
  Future<void> updateInstallmentPayment({
    required String studentId,
    required String installmentId,
    required double paidAmount,
    DateTime? paidDate,
    String? paymentMethod,
  }) async {
    try {
      final docRef = _firestore
          .collection('student_installment')
          .doc(studentId);
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception('Student installment document not found');
      }

      final data = doc.data()!;
      final List<dynamic> installments = List<dynamic>.from(
        data['installments'] ?? [],
      );

      final updatedInstallments =
          installments.map((e) {
            final m = Map<String, dynamic>.from(e as Map);
            if (m['id'] == installmentId) {
              m['paidAmount'] = paidAmount;
              m['paidDate'] = paidDate?.toIso8601String();
              m['paymentMethod'] = paymentMethod;
            }
            return m;
          }).toList();

      await docRef.update({
        'installments': updatedInstallments,
        'totalFee': data['totalFee'], // ✅ always keep totalFee in updates
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update installment: $e');
    }
  }
}
