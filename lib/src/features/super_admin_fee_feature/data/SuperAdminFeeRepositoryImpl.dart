import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/super_admin_fee_feature/domain/abstract_repo/super_admin_fee_repository.dart';

class SuperAdminFeeRepositoryImpl implements SuperAdminFeeRepository {
  // Inject your data source here later
  final FirebaseFirestore _remoteDataSource;
  static const String _collectionPath1 = "not_approved_fee_installments";
  static const String _collectionPath2 = "student_installment";

  SuperAdminFeeRepositoryImpl(this._remoteDataSource);
  @override
  Future<List<Map<String, dynamic>>> getNotifications() async {
    var a = await _remoteDataSource.collection(_collectionPath1).get();
    var b = a.docs;
    List<Map<String, dynamic>> c = [];
    for (var element in b) {
      c.add(element.data());
    }
    // debugPrint("$c");
    return c;
  }

  @override
  Future<void> confirmPayment(String id, String studentId) async {
    // Get a reference to your Firestore instance (assuming _remoteDataSource is FirebaseFirestore.instance)

    await _remoteDataSource.runTransaction((transaction) async {
      // Step 1: Read the document within the transaction
      final docRef = _remoteDataSource
          .collection(_collectionPath2)
          .doc(studentId);
      final snapshot = await transaction.get(docRef);

      // Check if the document exists before proceeding
      if (!snapshot.exists) {
        // Handle the case where the document doesn't exist
        print("Document for student $studentId does not exist!");
        // Optionally throw an error or return
        throw Exception("Student document not found.");
      }

      // Step 2: Extract data and modify locally
      final Map<String, dynamic>? data = snapshot.data();
      if (data == null || !data.containsKey("installments")) {
        print("Installments field missing or null for student $studentId");
        throw Exception("Installments data invalid.");
      }

      // Ensure we have a modifiable list
      // Create a new list to avoid modifying the snapshot's internal map directly
      double totalPaidSoFar = 0.0;
      List<Map<String, dynamic>> installments = List.from(data["installments"]);
      // installments.map((e) {
      //   final m = Map<String, dynamic>.from(e as Map);
      //   totalPaidSoFar += (m['paidAmount'] as num?)?.toDouble() ?? 0;
      //   return m;
      // });

      bool updated = false;
      for (var element in installments) {
        totalPaidSoFar = totalPaidSoFar + element["paidAmount"];
        if (element["id"] == id) {
          element["status"] = "Paid";
          updated = true;
          break; // Assuming 'id' is unique, we can stop after finding it
        }
      }
      // data["paidAmount"] = totalPaidSoFar;
      if (!updated) {
        print("Installment with id $id not found for student $studentId");
        throw Exception("Installment not found.");
      }

      // Step 3: Write the modified list back using the transaction
      transaction.update(docRef, {
        "installments": installments,
        "paidAmount": totalPaidSoFar,
      });
      print("Payment confirmed for installment $id of student $studentId.");
    }); // The transaction automatically retries if there are conflicts

    // |
    // |
    // V
    // NOW WITH _collectionPath1
    await _remoteDataSource.runTransaction((transaction) async {
      // Step 1: Read the document within the transaction
      final docRef = _remoteDataSource
          .collection(_collectionPath1)
          .doc(studentId);
      final snapshot = await transaction.get(docRef);

      // Check if the document exists before proceeding
      if (!snapshot.exists) {
        // Handle the case where the document doesn't exist
        print("Document for student $studentId does not exist!");
        // Optionally throw an error or return
        throw Exception("Student document not found.");
      }

      // Step 2: Extract data and modify locally
      final data = snapshot.data();
      if (data == null || !data.containsKey("installments")) {
        print("Installments field missing or null for student $studentId");
        throw Exception("Installments data invalid.");
      }

      // Ensure we have a modifiable list
      // Create a new list to avoid modifying the snapshot's internal map directly
      List<Map<String, dynamic>> installments = List.from(data["installments"]);

      double totalPaidSoFar = 0.0;
      bool updated = false;
      for (var element in installments) {
        totalPaidSoFar = totalPaidSoFar + element["paidAmount"];

        if (element["id"] == id) {
          element["status"] = "Paid";
          updated = true;
          var documentReference = _remoteDataSource.collection(
            "fee_history_daywise",
          );
          await documentReference.doc().set({
            "paidAmount": element["paidAmount"],
            "paymentMethod": element["paymentMethod"],
            // "paidDate": "$paidDate",
            "createdAt": FieldValue.serverTimestamp(),
          });
          break; // Assuming 'id' is unique, we can stop after finding it
        }
      }
      // data["paidAmount"] = totalPaidSoFar;

      if (!updated) {
        print("Installment with id $id not found for student $studentId");
        throw Exception("Installment not found.");
      }

      // Step 3: Write the modified list back using the transaction
      transaction.update(docRef, {
        "installments": installments,
        "paidAmount": totalPaidSoFar,
      });
      print("Payment confirmed for installment $id of student $studentId.");
    }); // The transaction automatically retries if there are conflicts
  }

  // @override
  // Future<void> deleteNotification(String id) async {
  //   // TODO: Implement using Firestore
  //   try {
  //     debugPrint("we are deleeting this document  $id");
  //     await _remoteDataSource.collection(_collectionPath1).doc(id).delete();
  //   } catch (e) {
  //     debugPrint("error  is $e");
  //   }
  // }

  // @override
  // Future<void> deleteAllPaid() async {
  //   // TODO: Implement using Firestore
  // }
}
