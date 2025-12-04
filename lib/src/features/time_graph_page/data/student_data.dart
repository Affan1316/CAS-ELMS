import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/presentation/pages/time_track_graph_page.dart';
import 'package:flutter_cas_app_main/src/features/workshop_geofencing/Domain/repository/shared_preference_repository.dart';

Future<DummyStudent?> getStudentData({String? givenNullableRollno}) async {
  SharePreferenceRepository sharePreferenceRepository =
      SharePreferenceRepository();

    String rollNo = givenNullableRollno?? await sharePreferenceRepository.getRollNo()??'';
    log(  rollNo, );

    var data =
        await FirebaseFirestore.instance
            .collection('students')
            .doc(rollNo)
            .get();
    if (data.exists) {
      Map<String, dynamic> data1 = data.data() as Map<String, dynamic>;
      return (
        name: data1["name"] as String,
        courseName: "...",
        batchName: data1["group"] as String,
        rollno: givenNullableRollno ,
      );
    }
  

}
