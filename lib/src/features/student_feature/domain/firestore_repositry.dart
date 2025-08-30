import 'package:flutter_cas_app_main/src/features/pay_fee/presentation/pages/group_detail_page.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';

abstract class FirestoreRepositry {
  addStudentDataToFirebase(StudentEntityClass student);
}
