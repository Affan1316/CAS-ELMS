import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/data/model/inquiry_model.dart';

class InquiryRemoteDataSource {
  final FirebaseFirestore firestore;

  InquiryRemoteDataSource(this.firestore);

  Future<void> addInquiry(InquiryModel inquiryModel) async {
    try {
      await firestore
          .collection('Inquiry Details')
          .doc(inquiryModel.id)
          .set(inquiryModel.toMap());
      if (kDebugMode) {
        print("✅ Inquiry added successfully: ${inquiryModel.toMap()}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to add Inquiry: $e");
      }
    }
  }

  Future<List<InquiryModel>> getInquiries() async {
    try {
      final snapshot = await firestore.collection('Inquiry Details').get();
      final inquiries = snapshot.docs
          .map((doc) => InquiryModel.fromMap(doc.data()))
          .toList();
      if (kDebugMode) {
        print("✅ Inquiries fetched successfully: $inquiries");
      }
      return inquiries;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Failed to fetch inquiries: $e");
      }
      rethrow;
    }
  }
}
