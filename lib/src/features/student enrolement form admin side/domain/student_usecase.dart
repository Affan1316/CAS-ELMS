import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/data/student.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/domain/firestore_repositry.dart';
import 'package:flutter_cas_app_main/src/features/student%20enrolement%20form%20admin%20side/presentation/bloc/student_enrollment_event.dart';

class StudentUsecase {
  FirestoreRepositry firestoreRepositry;
  Student? s;

  StudentUsecase(this.firestoreRepositry);
  provideStudentData(SubmitEnrollmentFormEvent studentData) {
    s = Student(
      id: studentData.id,
      name: studentData.name,
      email: studentData.email,
      cnic: studentData.cnic,
      phone: studentData.phone,
      address: studentData.address,
      gender: studentData.gender,
      fatherName: studentData.fatherName,
      fatherOccupation: studentData.fatherOccupation,
    );
    return _addStudent();
  }

  _addStudent() {
    return firestoreRepositry.addStudentDataToFirebase(s!);
  }
}
