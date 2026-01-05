import 'dart:async';
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
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/student_enrollment_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/widgets/student_card_action.dart';
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
  bool _isNavigating = false;
  bool _isUpdatingGroup = false;
  bool _isDeletingStudent = false;

  @override
  void initState() {
    super.initState();
    context.read<StudentFeatureBloc>().add(FetchGroupNamesEvent());
  }

  // Show loading dialog
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF5D5FEF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Loading student data...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Hide loading dialog
  void _hideLoadingDialog() {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // Show loading dialog for group update
  void _showGroupUpdateLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF3B82F6),
                        Color(0xFF5D5FEF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Moving student to group...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show loading dialog for delete operation
  void _showDeleteLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFEF4444),
                        Color(0xFFDC2626),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Deleting student...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Navigate to edit screen with loading dialog
  Future<void> _navigateToEditScreen(String studentId) async {
    if (_isNavigating) return;
    
    _isNavigating = true;
    _showLoadingDialog();

    try {
      // Fetch full student data
      context.read<StudentFeatureBloc>().add(
        FetchGroupStudentsEvent(id: studentId),
      );

      // Wait for the BLoC to emit the data
      final completer = Completer<StudentEntityClass>();
      
      final subscription = context.read<StudentFeatureBloc>().stream.listen((state) {
        if (state is GroupStudentsDatafetched && !completer.isCompleted) {
          final studentData = StudentEntityClass(
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
          );
          completer.complete(studentData);
        }
      });

      // Wait for data with timeout
      final studentData = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Timeout fetching student data');
        },
      );

      subscription.cancel();
      _hideLoadingDialog();

      // Navigate to edit screen
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentEnrollmentScreen(
              isEditMode: true,
              studentData: studentData,
            ),
          ),
        );
      }
    } catch (e) {
      _hideLoadingDialog();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading student data: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      _isNavigating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFFFFFFFF);
    final shadowColor = const Color(0xFFE5E7EB);
    final darkPurple = const Color(0xFF111827);
    final ReadWholeGroupStudentsListUsecase readWholeGroupStudentsListUsecase =
        ReadWholeGroupStudentsListUsecase();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(
          "Students of ${widget.groupTitle}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF5D5FEF),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: BlocConsumer<StudentFeatureBloc, StudentFeatureState>(
        listener: (context, state) {
          if (state is GroupNamesfetchingCompleted) {
            setState(() {
              listOfGroupNamesForDropDownMenu = state.listOfGroupNames;
            });
          }

          // This listener now ONLY handles card tap (view details)
          // Ignore if we're navigating
          if (state is GroupStudentsDatafetched && !_isNavigating) {
            _isNavigating = true;

            final studentData = StudentEntityClass(
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
            );

            // Only navigate to detail page from here (when tapping the card)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDetailPage(student: studentData),
              ),
            ).then((_) {
              _isNavigating = false;
            });
          }

          // Handle group update loading dialog
          if (state is StudentGroupUpdateSuccess) {
            // Close loading dialog if it's open
            if (_isUpdatingGroup) {
              Navigator.of(context, rootNavigator: true).pop();
              _isUpdatingGroup = false;
            }
            
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

          if (state is StudentGroupUpdateFailure) {
            // Close loading dialog if it's open
            if (_isUpdatingGroup) {
              Navigator.of(context, rootNavigator: true).pop();
              _isUpdatingGroup = false;
            }
            
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

          // Handle delete success
          if (state is StudentDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Student deleted successfully!'),
                  ],
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }

          // Handle delete failure
          if (state is StudentDeleteFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Delete failed: ${state.error}'),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
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
                return Center(
                  child: Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No students found"),
                );
              }

              final students = snapshot.data!.docs
                  .map(
                    (doc) => StudentFeatureGroupStudentEntityClass.fromMap(
                      doc.data(),
                    ),
                  )
                  .toList();

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
                      startActionPane: StudentCardActions.buildActionPane(
                        context: context,
                        studentId: student.rollNum,
                        studentName: student.name,
                        groupName: widget.groupTitle,
                        onEditGroup: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildGroupSelectionDialog(
                              context,
                              student.rollNum,
                            ),
                          );
                        },
                        onUpdateStudent: () {
                          // Navigate to edit screen with loading dialog
                          _navigateToEditScreen(student.rollNum);
                        },
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Prevent action if already navigating
                          if (_isNavigating) return;
                          
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
                                        color: darkPurple,
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
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                  color: const Color(0xFFE5E7EB),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Group Selection',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
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
                              color: const Color(0xFFE5E7EB),
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
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFF6B7280),
                            ),
                            style: const TextStyle(
                              color: Color(0xFF111827),
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
                InkWell(
                  onTap: listOfGroupNamesForDropDownMenu.isEmpty
                      ? null
                      : () {
                          final groupToAssign = selectedGroup ??
                              listOfGroupNamesForDropDownMenu.first;

                          // Close the group selection dialog first
                          Navigator.of(context).pop();
                          
                          // Show loading dialog and set flag
                          setState(() {
                            _isUpdatingGroup = true;
                          });
                          _showGroupUpdateLoadingDialog();
                          
                          // Trigger update event
                          context.read<StudentFeatureBloc>().add(
                                UpdateStudentGroupEvent(
                                  studentId: studentId,
                                  newGroupName: groupToAssign,
                                ),
                              );
                        },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: listOfGroupNamesForDropDownMenu.isEmpty
                            ? [Colors.grey, Colors.grey]
                            : [
                                const Color(0xFF3B82F6),
                                const Color(0xFF5D5FEF),
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Move Student to",
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