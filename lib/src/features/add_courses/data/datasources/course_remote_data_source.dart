import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/domain/entities/course.dart';

class CourseRemoteDataSource {
  final FirebaseFirestore firestore;

  CourseRemoteDataSource(this.firestore);

 Future<void> addCourses(Course course) async {
    try {
      final query = await firestore
          .collection("Courses")
          .where("name", isEqualTo: course.name.trim())
          .get();

      if (query.docs.isNotEmpty) {
        throw Exception("Course already exists");
      }
      await firestore.collection("Courses").doc(course.id).set(course.toMap());
      print("✅ Course added successfully: ${course.toMap()}");
    } catch (e) {
      print("❌ Failed to add course: $e");
      rethrow;
    }
  }

  Future<List<Course>> getCourses() async {
    final snapshot = await firestore.collection('Courses').get();
    return snapshot.docs.map((doc) {
      return Course(id: doc.id, name: doc['name']);
    }).toList();
  }
}
