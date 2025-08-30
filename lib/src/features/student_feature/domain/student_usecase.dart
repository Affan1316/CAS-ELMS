import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_enrollment_event.dart';

import '../data/student_entity_class.dart';

class StudentUsecase {
  FirestoreRepositry firestoreRepositry;
  StudentEntityClass? s;

  StudentUsecase(this.firestoreRepositry);
  provideStudentData(SubmitEnrollmentFormEvent studentData) {
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
    return _addStudent();
  }

  _addStudent() {
    return firestoreRepositry.addStudentDataToFirebase(s!);
  }
}
