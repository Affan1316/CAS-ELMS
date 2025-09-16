import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/read_whole_group_students_list_usecase.dart';

class ReadgroupstudentsforfeeUseCase {
  final ReadWholeGroupStudentsListUsecase studentFeatureUseCase =
      ReadWholeGroupStudentsListUsecase();
  Stream<QuerySnapshot<Map<String, dynamic>>> read(String groupTitle) {
    return studentFeatureUseCase.readWholeGroupStudents(groupTitle);
  }
}
