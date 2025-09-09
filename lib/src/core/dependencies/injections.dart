import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_cas_app_main/src/features/add_courses/presentation/courses_injections.dart';
import 'package:flutter_cas_app_main/src/features/inquiry/inquiry_injections.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  await initInquiry(sl);
  await initCourses(sl);
}
