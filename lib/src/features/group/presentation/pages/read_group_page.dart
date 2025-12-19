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
    // Colors updated based on palette
    final darkPurple = const Color(0xFF111827); // Replaced with Primary Text
    final cardColor = const Color(0xFFFFFFFF); // Component Background
    final shadowColor = const Color(0xFFE5E7EB); // Border/Shadow Color
    final readgroupUsecase = ReadGroupUsecase(
      abstractGroupRepository: GroupRepositoryImplementation(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), // App Background
      appBar: AppBar(
        title: const Text('All Groups', style: TextStyle(color: Colors.white)),
        centerTitle: true,
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
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0,
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
                          color: shadowColor, // Updated shadow color
                          blurRadius: 15,
                          offset: const Offset(4, 4), // Adjusted offset
                        ),
                        const BoxShadow(
                          color: Colors.white,
                          blurRadius: 15,
                          offset: Offset(-4, -4), // Adjusted offset
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
                                  color: darkPurple, // Primary Text
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF3B82F6), // Primary Color
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
            return const Center(child: CircularProgressIndicator());
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
                color: Color(0xFF374151), // Secondary Text (Slate Gray)
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF111827), // Primary Text (Dark Charcoal)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
