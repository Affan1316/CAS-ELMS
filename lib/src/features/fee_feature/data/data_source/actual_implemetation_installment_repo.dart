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
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/fee_installment_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/student_fee_feature_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/domain/abstract_repo/abstract_implemetation_installment_repo.dart';
import 'package:uuid/uuid.dart';

class ActualImplemetationInstallmentRepo implements AbstractInstallmentRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  @override
  /// Creates / replaces the document in student_installment/{studentId}
  Future<void> createStudentWithInstallments({
    required double paidAmount,
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
          final FeeInstallmentEntityClass inst = FeeInstallmentEntityClass(
            id: _uuid.v4(),
            title: 'Installment ${i + 1}',
            totalAmount: amountPerMonth,
            dueDate: dueDate,
            paidDate: null,
            paymentMethod: null,
            status: 'Unpaid',
            paidAmount: paidAmount,
          );
          return inst.toMap();
        },
      );

      final Map<String, dynamic> payload = {
        'id': studentId,
        'name': name,

        "paidAmount": paidAmount,

        'groupId': groupId,
        'totalFee': totalFee,
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

  @override
  Future<StudentFeeFeatureEntityClass?> getStudent(String studentId) async {
    try {
      final doc =
          await _firestore
              .collection('student_installment')
              .doc(studentId)
              .get();

      if (!doc.exists) {
        print("<<<<<<<<doc does not exits >>>>>>>>>>>");
        return null;
      }
      final data = doc.data()!;
      debugPrint("fetched student data is $data");

      final Map<String, dynamic> normalized = {
        'id': data['id'] ?? studentId,
        'name': data['name'] ?? '',
        'groupId': data['groupId'] ?? '',
        'totalFee': data['totalFee'] ?? 0,
        'paidAmount': data['paidAmount'] ?? 0,

        'installments':
            (data['installments'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList(),
      };

      return StudentFeeFeatureEntityClass.fromMap(normalized);
    } catch (e) {
      throw Exception('Failed to fetch installment plan: $e');
    }
  }

  @override
  @override
  Future<void> updateInstallmentPayment({
    required String studentId,
    required String installmentId,
    required double paidAmount,
    required DateTime paidDate,
    required String paymentMethod,
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

      double totalPaidSoFar = 0;

      final updatedInstallments =
          installments.map((e) {
            final m = Map<String, dynamic>.from(e as Map);

            if (m['id'] == installmentId) {
              final double installmentTotal =
                  (m['totalAmount'] as num).toDouble();
              final double newPaid = paidAmount;

              m['paidAmount'] = newPaid;
              m['paidDate'] = (paidDate ?? DateTime.now()).toIso8601String();
              m['paymentMethod'] = paymentMethod;

              // Update status based on payment
              if (newPaid >= installmentTotal) {
                m['status'] = 'Paid';
              } else if (newPaid > 0 && newPaid < installmentTotal) {
                m['status'] = 'Partial';
              } else {
                m['status'] = 'Unpaid';
              }
            }

            totalPaidSoFar += (m['paidAmount'] as num?)?.toDouble() ?? 0;
            return m;
          }).toList();

      await docRef.update({
        'installments': updatedInstallments,
        'paidAmount': totalPaidSoFar, // keep student-level summary
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update installment: $e');
    }

    // var secondDocId = _firestore.collection("fee_history_daywise").id;

    // if (secondDocId.isEmpty) {
    //   _firestore.collection("fee_history_daywise").doc("$paidDate").set({
    //     "fees": [
    //       {
    //         "paidAmount": "$paidAmount",
    //         "paymentMethod": "$paymentMethod",
    //         "paidDate": "$paidDate",
    //       },
    //     ],
    //   });
    // } else {

    var documentReference = _firestore.collection("fee_history_daywise");
    documentReference.doc().set({
      "paidAmount": "$paidAmount",
      "paymentMethod": "$paymentMethod",
      // "paidDate": "$paidDate",
      "createdAt": FieldValue.serverTimestamp(),
    });

    // int day = paidDate.day;
    // int month = paidDate.month;
    // int year = paidDate.year;
    // DocumentReference<Map<String, dynamic>> documentReference = _firestore
    //     .collection("fee_history_daywise")
    //     .doc("$day-$month-$year");

    // var a = await documentReference.get();
    // Map<String, dynamic>? mapOflist = a.data();

    // if (mapOflist == null) {
    //   documentReference.set({
    //     "fees": [
    //       {
    //         "paidAmount": "$paidAmount",
    //         "paymentMethod": "$paymentMethod",
    //         "paidDate": "$paidDate",
    //       },
    //     ],
    //   });
    // } else {
    //   List fetchedListOfFees = mapOflist["fees"];
    //   fetchedListOfFees.add({
    //     "paidAmount": "$paidAmount",
    //     "paymentMethod": "$paymentMethod",
    //     "paidDate": "$paidDate",
    //   });
    //   mapOflist["fees"] = fetchedListOfFees;
    //   documentReference.set(mapOflist);
    // }

    // }
  }
}
