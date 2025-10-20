import 'package:flutter_cas_app_main/src/features/student_feature/data/actual_implementation_firebase_repo.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/firestore_repositry.dart';

class GetGroupsNamesUsecase {
  FirestoreRepositry firestoreRepositry = ActualImplementationFirebaseRepo();

  getGroupNames() {
    return firestoreRepositry.getGroupsNames();
  }
}
