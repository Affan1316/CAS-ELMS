import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/data/model/leave_model.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';

class LeaveRemoteDataSource {
  final FirebaseFirestore firestore;

  LeaveRemoteDataSource(this.firestore);

  Future<void> addleave(Leave leave)async{
    try{
       await firestore
       .collection('Request Leave')
       .doc(leave.id)
       .set(leave.toMap());
      if (kDebugMode) {
        print("✅ Request Leave added successfully: ${leave.toMap()}");
      }
    }catch (e) {
      if (kDebugMode) {
        print("❌ Failed to add Request Leave: $e");
      }
    }
  }

  Future<List<Leave>> getLeave() async {
    try {
      final snapshot = await firestore.collection('Request Leave').get();
      final leaves = snapshot.docs
          .map((doc) => Leave.fromMap(doc.data()))
          .toList();
      if (kDebugMode) {
        print("✅ Request Leaves fetched successfully: $Leave");
      }
      return leaves;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to fetch request leave: $e");
      }
      rethrow;
    }
  }

  Future<void> updateStatus(Leave leave)async{
    try{
      await firestore
      .collection("Request Leave")
      .doc(leave.id)
      .update(leave.toMap());
      if (kDebugMode) {
        print("✅ Leave Status Update successfully: $LeaveModel");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to Update Leave Status: $e");
      }
      rethrow;
    }
  }

  
}
