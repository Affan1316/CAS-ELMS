import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/full_screen_image.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/group_student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/domain/read_whole_group_students_list_usecase.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/StudentDetailPage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroupStudentsScreen extends StatelessWidget {
  final String groupTitle;
  // final List<Student> students;

  const GroupStudentsScreen({
    super.key,
    required this.groupTitle,
    // required this.students,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white;
    final shadowColor = const Color(0xFFB0D6F9);
    final darkPurple = const Color(0xFF3D0075);
    final ReadWholeGroupStudentsListUsecase readWholeGroupStudentsListUsecase =
        ReadWholeGroupStudentsListUsecase();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Students of $groupTitle",
          style: const TextStyle(color: Color(0xFF3D0075)),
        ),
        backgroundColor: const Color(0xFFEAF6FF),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF3D0075)),
      ),
      body: BlocConsumer<StudentFeatureBloc, StudentFeatureState>(
        listenWhen: (previous, current) => current is GroupStudentsDatafetched,

        listener: (context, state) {
          if (state is GroupStudentsDatafetched) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StudentDetailPage(
                    student: StudentEntityClass(
                      id: state.id,
                      name: state.name,
                      email: state.email,
                      cnic: state.cnic,
                      phone: state.phone,
                      address: state.address,
                      gender: state.gender,
                      fatherName: state.fatherName,
                      fatherOccupation: state.fatherOccupation,
                      group: state.group,
                    ),
                  );
                },
              ),
            );
          }
        },
        builder: (context, state) {
          var students = [];
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: readWholeGroupStudentsListUsecase.readWholeGroupStudents(
              groupTitle,
            ),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No students found"));
              }
              print("@@@@@@@@@@@@@ we are runing erro line now CAS CAS CAS ");
              snapshot.data!.docs.map((e) {
                print(e.data());
              });
              // Data  ready to reaad
              students =
                  snapshot.data!.docs
                      .map(
                        (doc) => StudentFeatureGroupStudentEntityClass.fromMap(
                          doc.data(),
                        ),
                      )
                      .toList();
              print(students);

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 400 + index * 80),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, (1 - value) * 20),
                          child: child,
                        ),
                      );
                    },
                    child: Slidable(
                      key: ValueKey(student.rollNum),
                      startActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) =>
                                        _buildGroupSelectionDialog(context),
                              );
                            },
                            backgroundColor: Colors.blue.shade100,
                            foregroundColor: Colors.blue,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Deleted ${student.name}'),
                                ),
                              );
                            },
                            backgroundColor: Colors.red.shade100,
                            foregroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.read<StudentFeatureBloc>().add(
                            FetchGroupStudentsEvent(id: student.rollNum),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFB0D6F9).withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(6, 6),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                blurRadius: 10,
                                offset: Offset(-6, -6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Open full screen image on tap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const FullScreenImage(
                                            imagePath:
                                                "assets/images/student-male.png",
                                          ),
                                    ),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Color(0xFF009688),
                                  backgroundImage: AssetImage(
                                    "assets/images/student-male.png",
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF3D0075),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.rollNum,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Chip(
                              //   label: const Text("Active"),
                              //   backgroundColor: Colors.green.shade50,
                              //   labelStyle: const TextStyle(
                              //     color: Colors.green,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupSelectionDialog(BuildContext context) {
    String? selectedGroup;
    final List<String> groups = [
      'AI Group',
      'Web Development',
      'Data Science',
      'Mobile Development',
      'UI/UX Design',
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Group Selection',
                  style: TextStyle(
                    color: Color(0xFF4A6FA5),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Dropdown field with minimal shadow
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        spreadRadius: 0,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedGroup ?? groups.first,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.group,
                        color: Color(0xFF4A6FA5),
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF4A6FA5),
                    ),
                    style: const TextStyle(
                      color: Color(0xFF4A6FA5),
                      fontSize: 16,
                    ),
                    items:
                        groups.map((String group) {
                          return DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGroup = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Add Group button with minimal shadow
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Group "${selectedGroup ?? groups.first}" added successfully!',
                        ),
                        backgroundColor: const Color(0xFF4A6FA5),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FA5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add Group",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.add, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
