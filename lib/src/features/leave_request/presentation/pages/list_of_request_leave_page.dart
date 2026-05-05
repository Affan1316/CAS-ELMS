// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/generate_new_leave_page.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/custom_floating_button.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_cards.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_details_model.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_header.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

// class ListOfRequestLeaveScreen extends StatefulWidget {
//   final String section;
//   final String studentName;
//   const ListOfRequestLeaveScreen({
//     required this.section,
//     required this.studentName,
//     super.key,
//   });

//   @override
//   State<ListOfRequestLeaveScreen> createState() => _LeaveScreenState();
// }

// class _LeaveScreenState extends State<ListOfRequestLeaveScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();

//     context.read<LeaveBloc>().add(
//       FetchLeaveRequest(
//         studentName: widget.studentName,
//         isAdmin: false, // Student view
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _navigateToNewLeavePage() async {
//     final result = await Navigator.push(
//       context,
//       PageRouteBuilder(
//         pageBuilder:
//             (context, animation, secondaryAnimation) =>
//                 GenerateNewLeaveRequestPage(
//                   section: widget.section,
//                   studentName: widget.studentName,
//                 ),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return SlideTransition(
//             position: animation.drive(
//               Tween<Offset>(
//                 begin: const Offset(1.0, 0.0),
//                 end: Offset.zero,
//               ).chain(CurveTween(curve: Curves.easeInOut)),
//             ),
//             child: child,
//           );
//         },
//       ),
//     );

//     if (result != null) {
//       context.read<LeaveBloc>().add(
//         FetchLeaveRequest(studentName: widget.studentName, isAdmin: false),
//       );
//     }
//   }

//   void _showLeaveDetails(Map<String, dynamic> item) {
//     LeaveDetailsModal.show(context, item);
//   }

//   double _getResponsiveFontSize(
//     double screenWidth,
//     double mobile,
//     double tablet,
//   ) {
//     if (screenWidth >= 768) return tablet;
//     return mobile;
//   }

//   // Helper method to map Leave entity to the format expected by LeaveCard
//   Map<String, dynamic> _mapLeaveToItem(Leave leave) {
//     Color statusColor;
//     switch (leave.status.toLowerCase()) {
//       case 'approved':
//         statusColor = const Color(0xFF34C759);
//         break;
//       case 'declined':
//       case 'rejected':
//         statusColor = const Color(0xFFFF3B30);
//         break;
//       default:
//         statusColor = const Color(0xFFFF9500);
//     }

//     // Determine category based on leaveType or set default
//     String category = 'Casual';
//     if (leave.leaveType.toLowerCase().contains('sick') == true) {
//       category = 'Sick';
//     } else if (leave.leaveType.toLowerCase().contains('emergency') == true) {
//       category = 'Emergency';
//     }

//     return {
//       'type': leave.leaveType ?? 'Leave Application',
//       'date': leave.fromDate ?? 'Unknown date',
//       'fromDate': leave.fromDate ?? '',
//       'toDate': leave.toDate ?? '',
//       'category': category,
//       'status': leave.status ?? 'Pending',
//       'statusColor': statusColor,
//       'reason': leave.reason ?? '',
//       'appliedDate':
//           leave.currentDate ?? DateFormat('dd MMM yyyy').format(DateTime.now()),
//     };
//   }

//   String _formatDateRange(String? fromDate, String? toDate) {
//     if (fromDate == null) return 'Unknown date';

//     if (toDate == null || toDate.isEmpty || fromDate == toDate) {
//       return fromDate;
//     }

//     return '$fromDate - $toDate';
//   }

//   List<Leave> _getFilteredLeaves(List<Leave> leaves) {
//     if (_searchQuery.isEmpty) {
//       return leaves;
//     }
//     return leaves.where((leave) {
//       return leave.leaveType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//              leave.status.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//              (leave.reason.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
//              (leave.fromDate.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isTablet = screenWidth >= 768;
//     final safePadding = MediaQuery.of(context).padding;

//     // Responsive dimensions
//     final horizontalPadding = isTablet ? 32.0 : 24.0;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // New Neumorphic Header with Search
//           LeaveHeader(
//             height: 200,
//             horizontalPadding: horizontalPadding,
//             onBackPressed: () => Navigator.pop(context),
//             onSearchChanged: (value) {
//               setState(() {
//                 _searchQuery = value;
//               });
//             },
//           ),

//           // Content section
//           Expanded(
//             child: Container(
//               width: double.infinity,
//               constraints:
//                   isTablet ? const BoxConstraints(maxWidth: 1200) : null,
//               margin:
//                   isTablet
//                       ? EdgeInsets.symmetric(
//                         horizontal:
//                             (screenWidth - 1200).clamp(0, double.infinity) /
//                             2,
//                       )
//                       : null,
//               padding: EdgeInsets.only(
//                 top: isTablet ? 24 : 20,
//                 left: horizontalPadding,
//                 right: horizontalPadding,
//                 bottom: horizontalPadding,
//               ),
//               child: BlocConsumer<LeaveBloc, LeaveState>(
//                 listener: (context, state) {
//                   if (state is LeaveFailure) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Error: ${state.message}'),
//                         backgroundColor: Colors.red,
//                         behavior: SnackBarBehavior.floating,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     );
//                   }
//                   // Listen for successful submission and refresh list
//                   if (state is LeaveSuccess) {
//                     context.read<LeaveBloc>().add(
//                       FetchLeaveRequest(
//                         studentName: widget.studentName,
//                         isAdmin: false,
//                       ),
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: isTablet ? 5 : 4,
//                             height: isTablet ? 28 : 24,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   AppColors.primary,      // Using AppColors
//                                   AppColors.primaryDark,  // Using AppColors
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                           SizedBox(width: isTablet ? 16 : 12),
//                           Text(
//                             'Recent Requests',
//                             style: TextStyle(
//                               fontSize: _getResponsiveFontSize(
//                                 screenWidth,
//                                 20,
//                                 24,
//                               ),
//                               fontWeight: FontWeight.bold,
//                               color: const Color(0xFF111827),
//                             ),
//                           ),
//                           const Spacer(),
//                           if (state is LeaveListLoaded)
//                             Text(
//                               '${_getFilteredLeaves(state.leaves).length} items',
//                               style: TextStyle(
//                                 fontSize: _getResponsiveFontSize(
//                                   screenWidth,
//                                   14,
//                                   16,
//                                 ),
//                                 color: const Color(0xFF6B7280),
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             )
//                           else if (state is LeaveLoading)
//                             SizedBox(
//                               width: 16,
//                               height: 16,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppColors.primary, // Using AppColors
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: isTablet ? 28 : 20),
//                       Expanded(
//                         child: _buildContent(state, screenWidth, isTablet),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: CustomFAB(onPressed: _navigateToNewLeavePage),
//       floatingActionButtonLocation:
//           isTablet
//               ? FloatingActionButtonLocation.endFloat
//               : FloatingActionButtonLocation.endFloat,
//     );
//   }

//   Widget _buildContent(LeaveState state, double screenWidth, bool isTablet) {
//     if (state is LeaveLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(
//                 AppColors.primary, // Using AppColors
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Loading leave requests...',
//               style: TextStyle(
//                 fontSize: _getResponsiveFontSize(screenWidth, 16, 18),
//                 color: const Color(0xFF6B7280),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (state is LeaveFailure) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: isTablet ? 80 : 64,
//               color: const Color(0xFFEF4444),
//             ),
//             SizedBox(height: isTablet ? 24 : 16),
//             Text(
//               'Failed to load requests',
//               style: TextStyle(
//                 fontSize: _getResponsiveFontSize(screenWidth, 16, 20),
//                 fontWeight: FontWeight.w600,
//                 color: const Color(0xFF1F2937),
//               ),
//             ),
//             SizedBox(height: isTablet ? 12 : 8),
//             Text(
//               state.message,
//               style: TextStyle(
//                 fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
//                 color: const Color(0xFF9CA3AF),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: isTablet ? 24 : 16),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<LeaveBloc>().add(
//                   FetchLeaveRequest(
//                     studentName: widget.studentName,
//                     isAdmin: false,
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary, // Using AppColors
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (state is LeaveListLoaded) {
//       final filteredLeaves = _getFilteredLeaves(state.leaves);

//       if (filteredLeaves.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.inbox_outlined,
//                 size: isTablet ? 80 : 64,
//                 color: const Color(0xFF9CA3AF),
//               ),
//               SizedBox(height: isTablet ? 24 : 16),
//               Text(
//                 _searchQuery.isEmpty ? 'No leave requests' : 'No results found',
//                 style: TextStyle(
//                   fontSize: _getResponsiveFontSize(screenWidth, 16, 20),
//                   fontWeight: FontWeight.w600,
//                   color: const Color(0xFF1F2937),
//                 ),
//               ),
//               SizedBox(height: isTablet ? 12 : 8),
//               Text(
//                 _searchQuery.isEmpty
//                     ? 'Tap + to create a new request'
//                     : 'Try searching with different keywords',
//                 style: TextStyle(
//                   fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
//                   color: const Color(0xFF9CA3AF),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }

//       return LayoutBuilder(
//         builder: (context, constraints) {
//           // Determine grid layout for tablets
//           if (isTablet && constraints.maxWidth > 800) {
//             return GridView.builder(
//               padding: EdgeInsets.zero,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: screenWidth > 1200 ? 2 : 1,
//                 childAspectRatio: screenWidth > 1200 ? 2.5 : 3.0,
//                 crossAxisSpacing: 24,
//                 mainAxisSpacing: 24,
//               ),
//               itemCount: filteredLeaves.length,
//               itemBuilder:
//                   (context, index) => LeaveCard(
//                     item: _mapLeaveToItem(filteredLeaves[index]),
//                     index: index,
//                     onTap:
//                         () => _showLeaveDetails(
//                           _mapLeaveToItem(filteredLeaves[index]),
//                         ),
//                   ),
//             );
//           } else {
//             return ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: filteredLeaves.length,
//               itemBuilder:
//                   (context, index) => LeaveCard(
//                     item: _mapLeaveToItem(filteredLeaves[index]),
//                     index: index,
//                     onTap:
//                         () => _showLeaveDetails(
//                           _mapLeaveToItem(filteredLeaves[index]),
//                         ),
//                   ),
//             );
//           }
//         },
//       );
//     }

//     // Default empty state
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.inbox_outlined,
//             size: isTablet ? 80 : 64,
//             color: const Color(0xFF9CA3AF),
//           ),
//           SizedBox(height: isTablet ? 24 : 16),
//           Text(
//             'No leave requests',
//             style: TextStyle(
//               fontSize: _getResponsiveFontSize(screenWidth, 16, 20),
//               fontWeight: FontWeight.w600,
//               color: const Color(0xFF1F2937),
//             ),
//           ),
//           SizedBox(height: isTablet ? 12 : 8),
//           Text(
//             'Tap + to create a new request',
//             style: TextStyle(
//               fontSize: _getResponsiveFontSize(screenWidth, 14, 16),
//               color: const Color(0xFF9CA3AF),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: ListOfRequestLeaveScreen
// Designer note: Full editorial facelift — zero logic / Firebase / BLoC changes.
// Philosophy: "Warm stone editorial" — mirrors StudentHomePage _Ink palette,
//             DM Serif Display headlines, newspaper rules, cream surfaces.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/domain/entities/leave.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/pages/generate_new_leave_page.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_details_model.dart';
import 'package:intl/intl.dart';

// ══════════════════════════════════════════════════════════════════════════════
// PALETTE — exact _Ink tokens from StudentHomePage
// ══════════════════════════════════════════════════════════════════════════════

class _Ink {
  static const pageBg = Color(0xFFF9F7F4);
  static const inkDeep = Color(0xFF1C1A17);
  static const inkMid = Color(0xFF5A5550);
  static const inkSoft = Color(0xFF8C8680);
  static const inkFaint = Color(0xFFB5B0A8);
  static const divider = Color(0xFFDDD9D3);
  static const surface = Color(0xFFFFFFFF);

  // Card accent tones
  static const sand = Color(0xFFEDE9E4);
  static const sage = Color(0xFFE4EDE7);
  static const lavender = Color(0xFFE9E4ED);
  static const mist = Color(0xFFE4EAE9);

  // Status colours (preserved from original)
  static const approved = Color(0xFF34C759);
  static const declined = Color(0xFFFF3B30);
  static const pending = Color(0xFFFF9500);
}

// ══════════════════════════════════════════════════════════════════════════════
// SCREEN — logic preserved 100%
// ══════════════════════════════════════════════════════════════════════════════

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
  // ── Logic: preserved exactly ───────────────────────────────────────────────
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
      FetchLeaveRequest(studentName: widget.studentName, isAdmin: false),
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

  Map<String, dynamic> _mapLeaveToItem(Leave leave) {
    Color statusColor;
    switch (leave.status.toLowerCase()) {
      case 'approved':
        statusColor = _Ink.approved;
        break;
      case 'declined':
      case 'rejected':
        statusColor = _Ink.declined;
        break;
      default:
        statusColor = _Ink.pending;
    }
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

  List<Leave> _getFilteredLeaves(List<Leave> leaves) {
    if (_searchQuery.isEmpty) return leaves;
    return leaves.where((leave) {
      return leave.leaveType.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          leave.status.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (leave.reason.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false) ||
          (leave.fromDate.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }
  // ── End preserved logic ────────────────────────────────────────────────────

  // ── Date string helper (editorial banner) ──────────────────────────────────
  String get _dateString {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _Ink.pageBg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Column(
            children: [
              // ── Editorial header slab ──────────────────────────────────────
              _EditorialHeader(
                studentName: widget.studentName,
                dateString: _dateString,
                searchQuery: _searchQuery,
                onBack: () => Navigator.pop(context),
                onSearchChanged: (v) => setState(() => _searchQuery = v),
              ),

              // ── Content ────────────────────────────────────────────────────
              Expanded(
                child: BlocConsumer<LeaveBloc, LeaveState>(
                  listener: (context, state) {
                    if (state is LeaveFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${state.message}'),
                          backgroundColor: _Ink.declined,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
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
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // ── Section row ───────────────────────────────────
                        SliverToBoxAdapter(
                          child: _SectionRow(
                            count:
                                state is LeaveListLoaded
                                    ? _getFilteredLeaves(state.leaves).length
                                    : null,
                            isLoading: state is LeaveLoading,
                          ),
                        ),

                        // ── List / states ─────────────────────────────────
                        _buildSliverContent(state),

                        const SliverToBoxAdapter(child: SizedBox(height: 120)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ── FAB — editorial dark-slab style ───────────────────────────────────
      floatingActionButton: _EditorialFAB(onPressed: _navigateToNewLeavePage),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSliverContent(LeaveState state) {
    if (state is LeaveLoading) {
      return const SliverFillRemaining(child: _LoadingState());
    }

    if (state is LeaveFailure) {
      return SliverFillRemaining(
        child: _ErrorState(
          message: state.message,
          onRetry:
              () => context.read<LeaveBloc>().add(
                FetchLeaveRequest(
                  studentName: widget.studentName,
                  isAdmin: false,
                ),
              ),
        ),
      );
    }

    if (state is LeaveListLoaded) {
      final filtered = _getFilteredLeaves(state.leaves);
      if (filtered.isEmpty) {
        return SliverFillRemaining(
          child: _EmptyState(isEmpty: _searchQuery.isEmpty),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _EditorialLeaveCard(
            item: _mapLeaveToItem(filtered[index]),
            index: index,
            onTap: () => _showLeaveDetails(_mapLeaveToItem(filtered[index])),
          ),
          childCount: filtered.length,
        ),
      );
    }

    return const SliverFillRemaining(child: _EmptyState(isEmpty: true));
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL HEADER — dateline + back + search
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialHeader extends StatelessWidget {
  final String studentName;
  final String dateString;
  final String searchQuery;
  final VoidCallback onBack;
  final ValueChanged<String> onSearchChanged;

  const _EditorialHeader({
    required this.studentName,
    required this.dateString,
    required this.searchQuery,
    required this.onBack,
    required this.onSearchChanged,
  });

  String get _firstName => studentName.split(' ').firstOrNull ?? studentName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _Ink.pageBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Dateline row ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back + pill
                Row(
                  children: [
                    GestureDetector(
                      onTap: onBack,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: _Ink.divider),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 13,
                            color: _Ink.inkMid,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _TagPill('Leave Edition'),
                  ],
                ),
                Text(
                  dateString,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _Ink.inkSoft,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          // ── Hairline ─────────────────────────────────────────────────────
          const Divider(height: 1, thickness: 0.8, color: _Ink.divider),

          // ── DM Serif headline ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Leave requests',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: _Ink.inkSoft,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _firstName,
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    color: _Ink.inkDeep,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '"Every absence tells a story. Tell yours clearly."',
                  style: TextStyle(
                    fontSize: 12,
                    color: _Ink.inkSoft,
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── Double editorial rule ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(height: 2.5, color: _Ink.inkDeep),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 0.8, color: _Ink.divider),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(height: 0.8, color: _Ink.divider),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Search field ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _EditorialSearchField(
              onChanged: onSearchChanged,
              query: searchQuery,
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: _Ink.divider),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 1.6,
          fontWeight: FontWeight.w500,
          color: _Ink.inkSoft,
        ),
      ),
    );
  }
}

class _EditorialSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String query;
  const _EditorialSearchField({required this.onChanged, required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: _Ink.sand,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _Ink.divider),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 13,
          color: _Ink.inkDeep,
          letterSpacing: 0.1,
        ),
        decoration: InputDecoration(
          hintText: 'Search by type, status, or date…',
          hintStyle: const TextStyle(fontSize: 13, color: _Ink.inkFaint),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 18,
            color: _Ink.inkSoft,
          ),
          suffixIcon:
              query.isNotEmpty
                  ? GestureDetector(
                    onTap: () => onChanged(''),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: _Ink.inkSoft,
                    ),
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION ROW — "Recent Requests" label + count
// ══════════════════════════════════════════════════════════════════════════════

class _SectionRow extends StatelessWidget {
  final int? count;
  final bool isLoading;
  const _SectionRow({this.count, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'RECENT REQUESTS',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
              color: _Ink.inkSoft,
            ),
          ),
          if (count != null)
            _TagPill('$count items')
          else if (isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(_Ink.inkMid),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL LEAVE CARD — warm stone, DM Serif type, status pill
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialLeaveCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final VoidCallback onTap;
  const _EditorialLeaveCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  State<_EditorialLeaveCard> createState() => _EditorialLeaveCardState();
}

class _EditorialLeaveCardState extends State<_EditorialLeaveCard> {
  bool _pressed = false;

  // Pick card tint by rotation (same logic as StudentHomePage feature cards)
  static const _tints = [_Ink.sand, _Ink.sage, _Ink.lavender, _Ink.mist];
  Color get _tint => _tints[widget.index % _tints.length];

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final status = item['status'] as String? ?? 'Pending';
    final type = item['type'] as String? ?? 'Leave Application';
    final category = item['category'] as String? ?? 'Casual';
    final from = item['fromDate'] as String? ?? '';
    final to = item['toDate'] as String? ?? '';
    final applied = item['appliedDate'] as String? ?? '';
    final reason = item['reason'] as String? ?? '';
    final Color statusColor = item['statusColor'] as Color? ?? _Ink.pending;

    final dateLabel = (to.isEmpty || from == to) ? from : '$from – $to';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.975 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _tint,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: type + status pill ───────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: type,
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: _Ink.inkDeep,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withOpacity(0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Hairline ─────────────────────────────────────────────
                Container(height: 0.8, color: _Ink.inkFaint.withOpacity(0.4)),
                const SizedBox(height: 10),

                // ── Meta row ─────────────────────────────────────────────
                Row(
                  children: [
                    _MetaChip(
                      icon: Icons.calendar_today_rounded,
                      label: dateLabel.isEmpty ? 'No date' : dateLabel,
                    ),
                    const SizedBox(width: 8),
                    _MetaChip(
                      icon: Icons.label_outline_rounded,
                      label: category,
                    ),
                  ],
                ),

                if (reason.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    reason,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _Ink.inkSoft,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                if (applied.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Applied: $applied',
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: _Ink.inkFaint,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _Ink.inkDeep.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: _Ink.inkSoft),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: _Ink.inkMid,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STATE WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_Ink.inkMid),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading leave requests…',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 18,
              color: _Ink.inkSoft,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: _Ink.inkFaint),
            const SizedBox(height: 16),
            Text(
              'Failed to load',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 22,
                color: _Ink.inkDeep,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: _Ink.inkSoft,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _Ink.inkDeep,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFF9F7F4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isEmpty;
  const _EmptyState({required this.isEmpty});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: _Ink.inkFaint),
          const SizedBox(height: 16),
          Text(
            isEmpty ? 'No requests yet' : 'No results found',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 22,
              color: _Ink.inkDeep,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEmpty
                ? 'Tap + below to create your first request'
                : 'Try different search keywords',
            style: const TextStyle(
              fontSize: 13,
              color: _Ink.inkSoft,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL FAB — dark slab matching StudentHomePage hero card style
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialFAB extends StatelessWidget {
  final VoidCallback onPressed;
  const _EditorialFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: _Ink.inkDeep,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _Ink.inkDeep.withOpacity(0.28),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, size: 18, color: Color(0xFFF9F7F4)),
            const SizedBox(width: 8),
            Text(
              'New Request',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFF9F7F4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
