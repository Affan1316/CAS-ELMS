import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/firestore_repositry.dart';
import 'student_entity_class.dart';

class ActualImplementationFirebaseRepo implements FirestoreRepositry {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String completeStudentsCollectionName = "students";
  ActualImplementationFirebaseRepo();
  @override
  addStudentDataToFirebase(StudentEntityClass student) async {
    print(
      "++++++++++++++++++++++executing second function___________________________",
    );

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

    print(
      "++++++++++++++++++++++ executing fitst function___________________________",
    );

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

  Future<List<String>> getGroupsNames() async {
    List<String> list = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      for (var doc in querySnapshot.docs) {
        list.add(doc.id);
        // print('Document ID: ${doc.id}');
        // print('Document data: ${doc.data()}'); // Access all fields
        // // You can also access specific fields like:
        // // print('User Name: ${doc.data()['name']}');
      }
    } catch (e) {
      list.add(e.toString());
      print("Error getting documents: $e");
    }
    return list;
  }
}


// .map((event) {
//       var a = event.docs;
//       var b;
//       List<GroupStudentEntityClass> list = [];
//       for (var element in a) {
//         b = element.data();
//         list.add(GroupStudentEntityClass.fromMap(b));
//       }
//     });