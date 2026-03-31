import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageService {
  /////////////////////////  SINGLETON PATTERN  ///////////////////////////////////

  static final ProfileImageService _instance =
      ProfileImageService._privateConstructor();

  factory ProfileImageService() {
    return _instance;
  }

  ProfileImageService._privateConstructor();
  /////////////////////////////////////////////////////////////////////////////////

  static const String _key =
      "profile_image_base64_"; // Appending ID to key is better for multi-user

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery, compress it, convert to Base64, save to SharedPreferences & Firestore
  Future<String?> pickAndSaveImage({
    required String studentId,
    required String groupName,
  }) async {
    try {
      // Compress the image during picking to avoid Firestore 1MB document limit
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512, // Resize to reasonable profile pic size
        maxHeight: 512,
        imageQuality: 70, // Compress quality to 70%
      );

      log("picked file is null ${pickedFile == null}");
      if (pickedFile == null) return null;

      File file = File(pickedFile.path);
      List<int> imageBytes = await file.readAsBytes();

      // Check if still too large for Firestore (1MB limit)
      if (imageBytes.length > 1000000) {
        log(
          "Image still too large after compression: ${imageBytes.length} bytes",
        );
        // You might want to show a toast or further compress here
      }

      String base64Image = base64Encode(imageBytes);

      // Save to SharedPreferences (using studentId to distinguish)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key + studentId, base64Image);

      /// 🔥 Firestore Upload
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .set({'profile_image': base64Image}, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection("$groupName students")
          .doc(studentId)
          .set({'profile_image': base64Image}, SetOptions(merge: true));

      return base64Image;
    } catch (e) {
      log("Error picking/saving image: $e");
      return null;
    }
  }

  /// Fetch image from SharedPreferences or Firestore
  Future<String?> getSavedImageBase64({required String studentId}) async {
    final prefs = await SharedPreferences.getInstance();

    // 1️⃣ Check local storage first
    String? base64Image = prefs.getString(_key + studentId);

    if (base64Image != null && base64Image.isNotEmpty) {
      return base64Image;
    }

    // 2️⃣ If not found locally, try Firestore
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(studentId)
              .get();

      if (doc.exists) {
        String? firestoreImage = doc.data()?['profile_image'];

        if (firestoreImage != null && firestoreImage.isNotEmpty) {
          // Save locally for next time
          await prefs.setString(_key + studentId, firestoreImage);
          return firestoreImage;
        }
      }
    } catch (e) {
      log("Error fetching from Firestore: $e");
    }

    return null;
  }
}
