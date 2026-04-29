import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';

import '../data/student_entity_class.dart';

class AddStudentUseCase {
  FirestoreRepositry firestoreRepositry;
  StudentEntityClass? s;

  AddStudentUseCase(this.firestoreRepositry);

  Future<void> provideStudentData(SubmitEnrollmentFormEvent studentData) async {
    s = StudentEntityClass(
      id: studentData.id,
      name: studentData.name,
      email: studentData.email,
      cnic: studentData.cnic,
      phone: studentData.phone,
      address: studentData.address,
      gender: studentData.gender,
      fatherName: studentData.fatherName,
      fatherOccupation: studentData.fatherOccupation,
      group: studentData.group,
    );
    await _addStudent();
  }

  Future<void> _addStudent() async {
    debugPrint("📝 Creating student: ${s!.id} (${s!.name})");

    // Step 1: Write to group students collection
    await firestoreRepositry.addStudentDataAccordingToGroupsToFirebase(s!);
    debugPrint("✅ Written to group students: ${s!.group} students");

    // Step 2: Write to main students collection
    // This method internally calls addStudentDataAccordingToGroupsToFirebase again
    // and also creates the student_installment document (auto-created fix)
    await firestoreRepositry.addStudentDataToFirebase(s!);
    debugPrint("✅ Written to main students collection");

    debugPrint("🎉 Student creation complete: ${s!.id}");
  }
}
