
import 'package:flutter_cas_app_main/src/features/add_courses/domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.name,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
