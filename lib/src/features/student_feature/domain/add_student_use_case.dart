import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';

import '../data/student_entity_class.dart';

class AddStudentUseCase {
  FirestoreRepositry firestoreRepositry;
  StudentEntityClass? s;

  AddStudentUseCase(this.firestoreRepositry);
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
    print(
      "++++++++++++++++++++++Calling fitst function___________________________",
    );
    firestoreRepositry.addStudentDataAccordingToGroupsToFirebase(s!);
    print(
      "++++++++++++++++++++++Calling second function___________________________",
    );

    return firestoreRepositry.addStudentDataToFirebase(s!);
  }
}
