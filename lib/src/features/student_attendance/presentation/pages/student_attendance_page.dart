// student_attendance.dart
// A simple responsive Flutter screen that shows a student's attendance by date
// Fonts are kept static (textScaleFactor = 1.0) so they don't scale with system font size.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/domain/entities/attendance.dart';
import 'package:flutter_cas_app_main/src/features/student_attendance/presentation/bloc/student_attendance_bloc.dart';
import 'package:intl/intl.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  // Helper: parse and format date string
  String _formatDate(String dateString) {
    final dt = DateTime.parse(dateString);
    return DateFormat.yMMMMd().format(dt); // e.g. September 1, 2025
  }

  String selectedAttendanceTimeline = 'all';

  @override
  Widget build(BuildContext context) {
    // Make font sizes static by forcing textScaleFactor to 1.0 for the subtree
    final mq = MediaQuery.of(context);
    final media = mq.copyWith(textScaleFactor: 1.0);

    return MediaQuery(
      data: media,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance — Student View'),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                setState(() {
                  selectedAttendanceTimeline = value;
                });
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'Last 3 days',
                      child: Text('Last 3 days'),
                    ),
                    PopupMenuItem(
                      value: 'Last 7 days',
                      child: Text('Last 7 days'),
                    ),
                    PopupMenuItem(
                      value: 'Last 1 month',
                      child: Text('Last 1 month'),
                    ),
                    PopupMenuItem(
                      value: 'Last 3 month',
                      child: Text('Last 3 month'),
                    ),
                    PopupMenuItem(value: 'all', child: Text('All Attendance')),
                  ],
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Use MediaQuery to decide layout breakpoints
            final width = constraints.maxWidth;

            // Choose columns based on available width
            final isWide =
                width >= 700; // arbitrary breakpoint for tablet/desktop
            final crossAxisCount = isWide ? 3 : 1;

            // Static font sizes (not responsive) as requested
            const titleFontSize = 18.0;
            const dateFontSize = 14.0;
            const statusFontSize = 13.0;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        child: Text('F', style: TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'F17-02',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Class: 10-A',
                            style: TextStyle(fontSize: dateFontSize),
                          ),
                        ],
                      ),
                      // const Spacer(),
                      // // Summary pill
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //   decoration: BoxDecoration(
                      //     color: Colors.blue.shade50,
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: const [
                      //       Text('Total Days', style: TextStyle(fontSize: 12)),
                      //       SizedBox(height: 2),
                      //       Text('7', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Grid/List of date cards showing present/absent
                  Expanded(
                    child: BlocBuilder<
                      StudentAttendanceBloc,
                      StudentAttendanceState
                    >(
                      builder: (context, state) {
                        if (state is StudentAttendanceLoadingState) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is StudentAttendanceLoadedState) {
                          List<Attendance> listOfAttendance;
                          if (selectedAttendanceTimeline == 'Last 3 days') {
                            listOfAttendance =
                                state.attendanceList.length > 3
                                    ? state.attendanceList.sublist(
                                      state.attendanceList.length - 3,
                                    )
                                    : state.attendanceList;
                          } else if (selectedAttendanceTimeline ==
                              'Last 7 days') {
                            listOfAttendance =
                                state.attendanceList.length > 7
                                    ? state.attendanceList.sublist(
                                      state.attendanceList.length - 7,
                                    )
                                    : state.attendanceList;
                          } else if (selectedAttendanceTimeline ==
                              'Last 1 month') {
                            listOfAttendance =
                                state.attendanceList.length > 30
                                    ? state.attendanceList.sublist(
                                      state.attendanceList.length - 30,
                                    )
                                    : state.attendanceList;
                          } else if (selectedAttendanceTimeline ==
                              'Last 3 month') {
                            listOfAttendance =
                                state.attendanceList.length > 90
                                    ? state.attendanceList.sublist(
                                      state.attendanceList.length - 90,
                                    )
                                    : state.attendanceList;
                          } else {
                            listOfAttendance = state.attendanceList;
                          }
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisExtent: 90, // card height (static)
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: listOfAttendance.length,
                            itemBuilder: (context, index) {
                              final item = listOfAttendance[index];
                              final dateStr =
                                  item.date.toString().split(' ')[0];
                              final present =
                                  item.status == 'present' ? true : false;

                              return _AttendanceCard(
                                dateLabel: _formatDate(dateStr),
                                present: present,
                                // static font sizes passed down
                                titleFontSize: titleFontSize,
                                dateFontSize: dateFontSize,
                                statusFontSize: statusFontSize,
                              );
                            },
                          );
                        } else if (state is StudentAttendanceErorState) {
                          return Center(child: Text(state.message));
                        } else {
                          return Text('No Data');
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final String dateLabel;
  final bool present;
  final double titleFontSize;
  final double dateFontSize;
  final double statusFontSize;

  const _AttendanceCard({
    super.key,
    required this.dateLabel,
    required this.present,
    required this.titleFontSize,
    required this.dateFontSize,
    required this.statusFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = present ? Colors.green.shade600 : Colors.red.shade600;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Date column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dateLabel,
                    style: TextStyle(
                      fontSize: dateFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.25)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    present ? 'Present' : 'Absent',
                    style: TextStyle(
                      fontSize: statusFontSize,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    present ? Icons.check_circle : Icons.cancel,
                    size: 18,
                    color: statusColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// To use this file:
// 1) Add `intl` package to your pubspec.yaml (for date formatting):
//    dependencies:
//      flutter:
//        sdk: flutter
//      intl: ^0.18.0
//
// 2) Import and push StudentAttendanceScreen() into your app's navigator or inside home:
//    runApp(MaterialApp(home: const StudentAttendanceScreen()));
