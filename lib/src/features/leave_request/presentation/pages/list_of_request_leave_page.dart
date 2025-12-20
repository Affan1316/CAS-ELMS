import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/generate_new_leave_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/custom_floating_button.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_cards.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_details_model.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_header.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

class ListOfRequestLeaveScreen extends StatefulWidget {
  final String section;
  final String studentName;
  const ListOfRequestLeaveScreen({
    required this.section,
    required this.studentName,
    super.key,
  });

  @override
  State<ListOfRequestLeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<ListOfRequestLeaveScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    context.read<LeaveBloc>().add(
      FetchLeaveRequest(
        studentName: widget.studentName,
        isAdmin: false, // Student view
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNewLeavePage() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                GenerateNewLeaveRequestPage(
                  section: widget.section,
                  studentName: widget.studentName,
                ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    );

    if (result != null) {
      context.read<LeaveBloc>().add(
        FetchLeaveRequest(studentName: widget.studentName, isAdmin: false),
      );
    }
  }

  void _showLeaveDetails(Map<String, dynamic> item) {
    LeaveDetailsModal.show(context, item);
  }

  double _getResponsiveFontSize(
    double screenWidth,
    double mobile,
    double tablet,
  ) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  // Helper method to map Leave entity to the format expected by LeaveCard
  Map<String, dynamic> _mapLeaveToItem(Leave leave) {
    Color statusColor;
    switch (leave.status.toLowerCase()) {
      case 'approved':
        statusColor = const Color(0xFF34C759);
        break;
      case 'declined':
      case 'rejected':
        statusColor = const Color(0xFFFF3B30);
        break;
      default:
        statusColor = const Color(0xFFFF9500);
    }

    // Determine category based on leaveType or set default
    String category = 'Casual';
    if (leave.leaveType.toLowerCase().contains('sick') == true) {
      category = 'Sick';
    } else if (leave.leaveType.toLowerCase().contains('emergency') == true) {
      category = 'Emergency';
    }

    return {
      'type': leave.leaveType ?? 'Leave Application',
      'date': leave.fromDate ?? 'Unknown date',
      'fromDate': leave.fromDate ?? '',
      'toDate': leave.toDate ?? '',
      'category': category,
      'status': leave.status ?? 'Pending',
      'statusColor': statusColor,
      'reason': leave.reason ?? '',
      'appliedDate':
          leave.currentDate ?? DateFormat('dd MMM yyyy').format(DateTime.now()),
    };
  }

  String _formatDateRange(String? fromDate, String? toDate) {
    if (fromDate == null) return 'Unknown date';

    if (toDate == null || toDate.isEmpty || fromDate == toDate) {
      return fromDate;
    }

    return '$fromDate - $toDate';
  }

  List<Leave> _getFilteredLeaves(List<Leave> leaves) {
    if (_searchQuery.isEmpty) {
      return leaves;
    }
    return leaves.where((leave) {
      return leave.leaveType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             leave.status.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (leave.reason?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
             (leave.fromDate?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    final safePadding = MediaQuery.of(context).padding;

    // Responsive dimensions
    final horizontalPadding = isTablet ? 32.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // New Neumorphic Header with Search
          LeaveHeader(
            height: 200,
            horizontalPadding: horizontalPadding,
            onBackPressed: () => Navigator.pop(context),
            onSearchChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),

          // Content section
          Expanded(
            child: Container(
              width: double.infinity,
              constraints:
                  isTablet ? const BoxConstraints(maxWidth: 1200) : null,
              margin:
                  isTablet
                      ? EdgeInsets.symmetric(
                        horizontal:
                            (screenWidth - 1200).clamp(0, double.infinity) /
                            2,
                      )
                      : null,
              padding: EdgeInsets.only(
                top: isTablet ? 24 : 20,
                left: horizontalPadding,
                right: horizontalPadding,
                bottom: horizontalPadding,
              ),
              child: BlocConsumer<LeaveBloc, LeaveState>(
                listener: (context, state) {
                  if (state is LeaveFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.message}'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                  // Listen for successful submission and refresh list
                  if (state is LeaveSuccess) {
                    context.read<LeaveBloc>().add(
                      FetchLeaveRequest(
                        studentName: widget.studentName,
                        isAdmin: false,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: isTablet ? 5 : 4,
                            height: isTablet ? 28 : 24,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primary,      // Using AppColors
                                  AppColors.primaryDark,  // Using AppColors
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          SizedBox(width: isTablet ? 16 : 12),
                          Text(
                            'Recent Requests',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(
                                screenWidth,
                                20,
                                24,
                              ),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF111827),
                            ),
                          ),
                          const Spacer(),
                          if (state is LeaveListLoaded)
                            Text(
                              '${_getFilteredLeaves(state.leaves).length} items',
                              style: TextStyle(
                                fontSize: _getResponsiveFontSize(
                                  screenWidth,
                                  14,
                                  16,
                                ),
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else if (state is LeaveLoading)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary, // Using AppColors
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: isTablet ? 28 : 20),
                      Expanded(
                        child: _buildContent(state, screenWidth, isTablet),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFAB(onPressed: _navigateToNewLeavePage),
      floatingActionButtonLocation:
          isTablet
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildContent(LeaveState state, double screenWidth, bool isTablet) {
    if (state is LeaveLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary, // Using AppColors
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading leave requests...',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(screenWidth, 16, 18),
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (state is LeaveFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 80 : 64,
              color: const Color(0xFFEF4444),
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'Failed to load requests',
              style: TextStyle(
                fontSize: _getResponsiveFontSize(screenWidth, 16, 20),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              state.message,
              style: TextStyle(
                fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
                color: const Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 24 : 16),
            ElevatedButton(
              onPressed: () {
                context.read<LeaveBloc>().add(
                  FetchLeaveRequest(
                    studentName: widget.studentName,
                    isAdmin: false,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Using AppColors
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is LeaveListLoaded) {
      final filteredLeaves = _getFilteredLeaves(state.leaves);

      if (filteredLeaves.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: isTablet ? 80 : 64,
                color: const Color(0xFF9CA3AF),
              ),
              SizedBox(height: isTablet ? 24 : 16),
              Text(
                _searchQuery.isEmpty ? 'No leave requests' : 'No results found',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(screenWidth, 16, 20),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                _searchQuery.isEmpty 
                    ? 'Tap + to create a new request'
                    : 'Try searching with different keywords',
                style: TextStyle(
                  fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          // Determine grid layout for tablets
          if (isTablet && constraints.maxWidth > 800) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 1200 ? 2 : 1,
                childAspectRatio: screenWidth > 1200 ? 2.5 : 3.0,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
              ),
              itemCount: filteredLeaves.length,
              itemBuilder:
                  (context, index) => LeaveCard(
                    item: _mapLeaveToItem(filteredLeaves[index]),
                    index: index,
                    onTap:
                        () => _showLeaveDetails(
                          _mapLeaveToItem(filteredLeaves[index]),
                        ),
                  ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredLeaves.length,
              itemBuilder:
                  (context, index) => LeaveCard(
                    item: _mapLeaveToItem(filteredLeaves[index]),
                    index: index,
                    onTap:
                        () => _showLeaveDetails(
                          _mapLeaveToItem(filteredLeaves[index]),
                        ),
                  ),
            );
          }
        },
      );
    }

    // Default empty state
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: isTablet ? 80 : 64,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: isTablet ? 24 : 16),
          Text(
            'No leave requests',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(screenWidth, 16, 20),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Tap + to create a new request',
            style: TextStyle(
              fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}