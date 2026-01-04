import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/firestore_repositry.dart';
import 'student_entity_class.dart';

class ActualImplementationFirebaseRepo implements FirestoreRepositry {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String completeStudentsCollectionName = "students";
  ActualImplementationFirebaseRepo();
  @override
  addStudentDataToFirebase(StudentEntityClass student) async {
    await addStudentDataAccordingToGroupsToFirebase(student);
    return await firestore
        .collection(completeStudentsCollectionName)
        .doc(student.id)
        .set({
          "name": student.name,
          "fatherName": student.fatherName,
          "address": student.address,
          "cnic": student.cnic,
          "gender": student.gender,
          "email": student.email,
          "fatherOccupation": student.fatherOccupation,
          "group": student.group,
          "phone": student.phone,
        });
  }

  @override
  addStudentDataAccordingToGroupsToFirebase(StudentEntityClass student) async {
    String collectionName = student.group;

    return await firestore
        .collection("$collectionName students")
        .doc(student.id)
        .set({"name": student.name, "rollNum": student.id});
  }

  @override
  Future<Map<String, dynamic>?> readStudentDataBasedOnId(String id) async {
    print("++++++++++++ Being fetched from firebase +++++++");
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection(completeStudentsCollectionName)
            .doc(id)
            .get();

    return documentSnapshot.data();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> readWholeGroupStudentsList(
    String groupTitle,
  ) {
    var a = firestore.collection("$groupTitle students").snapshots();
    return a;
  }

  @override
  Future<List<String>> getGroupsNames() async {
    List<String> list = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      for (var doc in querySnapshot.docs) {
        list.add(doc.id);
      }
    } catch (e) {
      list.add(e.toString());
      print("Error getting documents: $e");
    }
    return list;
  }
  
   @override
  Future<void> updateStudentGroup({
    required String studentId,
    required String newGroupName,
  }) async {
    try {
      // Step 1: Get current student data to know the old group
      DocumentSnapshot<Map<String, dynamic>> studentDoc = await firestore
          .collection(completeStudentsCollectionName)
          .doc(studentId)
          .get();

      if (!studentDoc.exists) {
        throw Exception('Student not found');
      }

      Map<String, dynamic>? studentData = studentDoc.data();
      if (studentData == null) {
        throw Exception('Student data is null');
      }

      String oldGroupName = studentData['group'] ?? '';
      String studentName = studentData['name'] ?? '';

      // Step 2: Update the main students collection with new group
      await firestore
          .collection(completeStudentsCollectionName)
          .doc(studentId)
          .update({'group': newGroupName});

      // Step 3: Remove student from old group collection (if exists)
      if (oldGroupName.isNotEmpty) {
        await firestore
            .collection("$oldGroupName students")
            .doc(studentId)
            .delete();
      }

      // Step 4: Add student to new group collection
      await firestore
          .collection("$newGroupName students")
          .doc(studentId)
          .set({
            "name": studentName,
            "rollNum": studentId,
          });

      print("✅ Student $studentId successfully moved from '$oldGroupName' to '$newGroupName'");
    } catch (e) {
      print("❌ Error updating student group: $e");
      throw Exception('Failed to update student group: ${e.toString()}');
    }
  }
}
