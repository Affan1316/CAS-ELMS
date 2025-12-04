import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_details_model.dart';
import '../widgets/responsive_header.dart';
import '../widgets/leave_request_card.dart';
import '../bloc/leave_bloc.dart';
import '../shared/enums.dart';

class AdminLeaveRequestManagement extends StatefulWidget {
  const AdminLeaveRequestManagement({super.key});

  @override
  _LeaveRequestManagementState createState() => _LeaveRequestManagementState();
}

class _LeaveRequestManagementState extends State<AdminLeaveRequestManagement> {
  List<Leave> allLeaves = [];

  @override
  void initState() {
    super.initState();
    // Fetch leaves when the page loads
    context.read<LeaveBloc>().add(
      FetchLeaveRequest(
        studentName: null,
        isAdmin: true,
      ),
    );
  }

  void updateLeaveStatus(int index, LeaveStatus newStatus) {
    if (index >= 0 && index < allLeaves.length) {
      final leaveToUpdate = allLeaves[index];

      // Create updated leave with new status using helper
      final updatedLeave = leaveToUpdate.copyWith(
        status: LeaveStatusHelper.leaveStatusToFirebaseString(newStatus),
      );

      // Update in Firebase through BLoC
      context.read<LeaveBloc>().add(LeaveStatusUpdateEvent(updatedLeave));
    }
  }

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  int getCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 40;
    if (isTablet(context)) return 24;
    return 16;
  }

  Widget buildResponsiveLeaveRequestsList(BuildContext context) {
    final crossAxisCount = getCrossAxisCount(context);
    final screenWidth = MediaQuery.of(context).size.width;

    if (crossAxisCount == 1) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: getHorizontalPadding(context),
        ),
        itemCount: allLeaves.length,
        itemBuilder: (context, index) {
          final leave = allLeaves[index];
          return LeaveRequestCard(
            leave: leave,
            originalIndex: index,
            onStatusUpdate: updateLeaveStatus,
            onViewDetails: (leave) => showRequestDetails(context, leave),
            isMobile: isMobile(context),
            isDesktop: isDesktop(context),
          );
        },
      );
    } else {
      return GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: getHorizontalPadding(context),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: screenWidth > 1200 ? 1.2 : 1.0,
        ),
        itemCount: allLeaves.length,
        itemBuilder: (context, index) {
          final leave = allLeaves[index];
          return LeaveRequestCard(
            leave: leave,
            originalIndex: index,
            onStatusUpdate: updateLeaveStatus,
            onViewDetails: (leave) => showRequestDetails(context, leave),
            isMobile: isMobile(context),
            isDesktop: isDesktop(context),
          );
        },
      );
    }
  }

  void showRequestDetails(BuildContext context, Leave leave) {
    final Map<String, dynamic> leaveData = {
      'type': leave.leaveType,
      'fromDate': leave.fromDate,
      'toDate': leave.toDate,
      'status': LeaveStatusHelper.leaveStatusToDisplayString(
        LeaveStatusHelper.stringToLeaveStatus(leave.status),
      ),
      'appliedDate': leave.currentDate,
      'reason': leave.reason,
      'studentName': leave.studentName,
      'id': leave.id,
      'section': leave.section,
    };
    LeaveDetailsModal.show(context, leaveData);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Using ResponsiveHeader but WITHOUT filter toggle
              ResponsiveHeader(
                showFilters: false, // Always false, no filter toggle
                onFilterToggle: () {}, // Empty callback, not used
                isMobile: isMobile(context),
                isDesktop: isDesktop(context),
                horizontalPadding: getHorizontalPadding(context),
                onBackPressed: () {
                  Navigator.pop(context);
                },
              ),
              // Removed ResponsiveFilters widget entirely
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(getHorizontalPadding(context)),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Recent Leave Requests",
                                style: TextStyle(
                                  fontSize: isDesktop(context) ? 22 : 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            BlocBuilder<LeaveBloc, LeaveState>(
                              builder: (context, state) {
                                final count = allLeaves.length;
                                if (count > 0) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6366F1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$count request${count != 1 ? 's' : ''}",
                                      style: TextStyle(
                                        color: Color(0xFF6366F1),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: BlocConsumer<LeaveBloc, LeaveState>(
                          listener: (context, state) {
                            if (state is LeaveStatusUpdated) {
                              context.read<LeaveBloc>().add(
                                    FetchLeaveRequest(
                                      studentName: null,
                                      isAdmin: true,
                                    ),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Leave status updated successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else if (state is LeaveStatusUpdateFailed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update leave status: ${state.error}',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LeaveLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF6366F1),
                                  ),
                                ),
                              );
                            } else if (state is LeaveListLoaded) {
                              allLeaves = state.leaves;

                              if (allLeaves.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: isDesktop(context) ? 80 : 60,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "No leave requests found",
                                        style: TextStyle(
                                          fontSize:
                                              isDesktop(context) ? 20 : 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return buildResponsiveLeaveRequestsList(context);
                            } else if (state is LeaveFailure) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: isDesktop(context) ? 80 : 60,
                                      color: Colors.red[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "Error loading leave requests",
                                      style: TextStyle(
                                        fontSize: isDesktop(context) ? 20 : 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      state.message,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.read<LeaveBloc>().add(
                                              FetchLeaveRequest(
                                                studentName: null,
                                                isAdmin: true,
                                              ),
                                            );
                                      },
                                      child: Text("Retry"),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: isDesktop(context) ? 80 : 60,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      "No leave requests available",
                                      style: TextStyle(
                                        fontSize: isDesktop(context) ? 20 : 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}