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

class GroupStudentsScreen extends StatefulWidget {
  final String groupTitle;

  const GroupStudentsScreen({
    super.key,
    required this.groupTitle,
  });

  @override
  State<GroupStudentsScreen> createState() => _GroupStudentsScreenState();
}

class _GroupStudentsScreenState extends State<GroupStudentsScreen> {
  List<String> listOfGroupNamesForDropDownMenu = [];

  @override
  void initState() {
    super.initState();
    // Fetch group names when screen loads
    context.read<StudentFeatureBloc>().add(FetchGroupNamesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFFFFFFFF); // Component Background
    final shadowColor = const Color(0xFFE5E7EB); // Borders/Shadow
    final darkPurple = const Color(0xFF111827); // Primary Text
    final ReadWholeGroupStudentsListUsecase readWholeGroupStudentsListUsecase =
        ReadWholeGroupStudentsListUsecase();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // App Background
      appBar: AppBar(
        title: Text(
          "Students of ${widget.groupTitle}",
          style: const TextStyle(
            color: Colors.white,
          ), // Text on Header must be White
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3B82F6), // Gradient Start
                Color(0xFF5D5FEF), // Gradient End
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Text/Icons on Header must be White
      ),
      body: BlocConsumer<StudentFeatureBloc, StudentFeatureState>(
        listener: (context, state) {
          // Listen for group names fetching
          if (state is GroupNamesfetchingCompleted) {
            setState(() {
              listOfGroupNamesForDropDownMenu = state.listOfGroupNames;
            });
          }

          // Listen for student details navigation
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

          // ← NEW: Listen for group update success
          if (state is StudentGroupUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Student moved to "${state.newGroupName}" successfully!',
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          // ← NEW: Listen for group update failure
          if (state is StudentGroupUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update group: ${state.error}'),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          var students = [];
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: readWholeGroupStudentsListUsecase.readWholeGroupStudents(
              widget.groupTitle,
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
                              // ← UPDATED: Pass student ID to dialog
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildGroupSelectionDialog(
                                  context,
                                  student.rollNum, // Pass student ID
                                ),
                              );
                            },
                            backgroundColor: const Color(0xFFE5E7EB),
                            foregroundColor: const Color(0xFF3B82F6),
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
                            color: cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
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
                                      builder: (_) => const FullScreenImage(
                                        imagePath:
                                            "assets/images/student-male.png",
                                      ),
                                    ),
                                  );
                                },
                                child: const CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Color(0xFF3B82F6),
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
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: darkPurple, // Primary Text
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      student.rollNum,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

  // ← UPDATED: Added studentId parameter
  Widget _buildGroupSelectionDialog(BuildContext context, String studentId) {
    String? selectedGroup;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), // Component Background
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                  color: const Color(0xFFE5E7EB), // Border/Shadow
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
                    color: Color(0xFF111827), // Primary Text
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Show loading or dropdown based on data availability
                listOfGroupNamesForDropDownMenu.isEmpty
                    ? const CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              spreadRadius: 0,
                              color: const Color(0xFFE5E7EB), // Border/Shadow
                            ),
                          ],
                        ),
                        child: Theme(
                          data: ThemeData.light().copyWith(
                            canvasColor: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedGroup ??
                                listOfGroupNamesForDropDownMenu.first,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.group,
                                color: Color(0xFF6B7280), // Input Icons
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF6B7280), // Input Icons
                            ),
                            style: const TextStyle(
                              color: Color(0xFF111827), // Primary Text
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white,
                            items: listOfGroupNamesForDropDownMenu
                                .map((String group) {
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
                      ),

                const SizedBox(height: 24),

                // ← UPDATED: Add Group button now triggers the update event
                BlocBuilder<StudentFeatureBloc, StudentFeatureState>(
                  builder: (context, state) {
                    final isUpdating = state is StudentGroupUpdating;

                    return InkWell(
                      onTap: (listOfGroupNamesForDropDownMenu.isEmpty ||
                              isUpdating)
                          ? null
                          : () {
                              final groupToAssign = selectedGroup ??
                                  listOfGroupNamesForDropDownMenu.first;

                              // ← TRIGGER THE UPDATE EVENT
                              context.read<StudentFeatureBloc>().add(
                                    UpdateStudentGroupEvent(
                                      studentId: studentId,
                                      newGroupName: groupToAssign,
                                    ),
                                  );

                              Navigator.of(context).pop();
                            },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (listOfGroupNamesForDropDownMenu.isEmpty ||
                                    isUpdating)
                                ? [Colors.grey, Colors.grey]
                                : [
                                    const Color(0xFF3B82F6), // Gradient Start
                                    const Color(0xFF5D5FEF), // Gradient End
                                  ],
                          ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isUpdating)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else ...[
                              const Text(
                                "Add Group",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.add, color: Colors.white),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}