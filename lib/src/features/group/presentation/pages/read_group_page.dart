import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/group/data/repositories/group_repository_implementation.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/entities/group_entity.dart';
import 'package:flutter_cas_app_main/src/features/group/domain/usecases/read_group_usecase.dart';
import 'package:flutter_cas_app_main/src/features/group/presentation/pages/update_group_screen.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/group_students_screen.dart';

class GroupMainDetailPage extends StatefulWidget {
  const GroupMainDetailPage({super.key});

  @override
  State<GroupMainDetailPage> createState() => _GroupMainDetailPageState();
}

class _GroupMainDetailPageState extends State<GroupMainDetailPage> {
  @override
  Widget build(BuildContext context) {
    final darkPurple = const Color(0xFF3D0075);
    final cardColor = Colors.white;
    final shadowColor = const Color(0xFFB0D6F9);
    final readgroupUsecase = ReadGroupUsecase(
      abstractGroupRepository: GroupRepositoryImplementation(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All Groups', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<List<GroupEntity>>(
        stream: readgroupUsecase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final group = snapshot.data?[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return GroupStudentsScreen(
                            groupTitle: group.groupName,
                            // students: [],
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(8, 8),
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 15,
                          offset: Offset(-8, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                group!.groupName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: darkPurple,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.deepPurple,
                              ),
                              tooltip: 'Edit Group',
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return
                                        // Container();
                                        UpdateGroupScreen(groupEntity: group);
                                      },
                                    ),
                                  ),
                              //  _editGroup(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _infoRow('Course: ', group.courseName),
                        _infoRow('Instructor: ', 'Sir Nauman Ameer Khan'),
                        _infoRow('Fee: ', 'PKR ${group.enterFee}'),
                        _infoRow('Duration: ', group.enterDuration),
                        _infoRow('Start Date: ', group.enterDate),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}




















































// onTap: () {
//                     final students = getDummyStudents(group.title);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (_) => StudentsScreen(
//                               groupTitle: group.title,
//                               students: students,
//                             ),
//                       ),
//                     );
//                   },




// List<Student> getDummyStudents(String groupTitle) {
  //   return [
  //     Student(name: 'Muzammil Ashraf', rollNumber: 'Ai-24'),
  //     Student(name: 'Muhammad Abdullah Waqar', rollNumber: 'Ai-08'),
  //     Student(name: 'Haroon Ashraf', rollNumber: 'Ai-02'),
  //     Student(name: 'Abdullah Qureshi', rollNumber: 'Ai-11'),
  //     Student(name: 'Gulraiz Javaid', rollNumber: 'Ai-09'),
  //     Student(name: 'Mushtaq Ahmed', rollNumber: 'Ai-23'),
  //   ];
  // }

  // void _editGroup(int index) {
  //   final group = _groups[index];
  //   final titleController = TextEditingController(text: group.title);
  //   final courseController = TextEditingController(text: group.course);
  //   final instructorController = TextEditingController(text: group.instructor);
  //   final feeController = TextEditingController(
  //     text: group.fee.toStringAsFixed(0),
  //   );
  //   final startTimeController = TextEditingController(text: group.startTime);
  //   final endTimeController = TextEditingController(text: group.endTime);

  //   showDialog(
  //     context: context,
  //     builder:
  //         (_) => AlertDialog(
  //           title: const Text('Edit Group'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 _buildTextField(titleController, 'Title'),
  //                 _buildTextField(courseController, 'Course'),
  //                 _buildTextField(instructorController, 'Instructor'),
  //                 _buildTextField(
  //                   feeController,
  //                   'Fee',
  //                   keyboardType: TextInputType.number,
  //                 ),
  //                 _buildTextField(startTimeController, 'Start Time'),
  //                 _buildTextField(endTimeController, 'End Time'),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('Cancel'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 setState(() {
  //                   _groups[index] = group.copyWith(
  //                     title: titleController.text,
  //                     course: courseController.text,
  //                     instructor: instructorController.text,
  //                     fee: double.tryParse(feeController.text) ?? group.fee,
  //                     startTime: startTimeController.text,
  //                     endTime: endTimeController.text,
  //                   );
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: const Text('Save'),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  // Widget _buildTextField(
  //   TextEditingController controller,
  //   String label, {
  //   TextInputType? keyboardType,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12),
  //     child: TextField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         filled: true,
  //         fillColor: const Color(0xFFEAF6FF),
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //       ),
  //     ),
  //   );
  // }