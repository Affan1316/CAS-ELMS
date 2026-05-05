// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
// import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_foam_feild.dart';
// import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart'; // Import AppColors

// class GenerateNewLeaveRequestPage extends StatefulWidget {
//   final String section;
//   final String studentName;
//   const GenerateNewLeaveRequestPage({
//     required this.section,
//     required this.studentName,
//     super.key,
//   });

//   @override
//   State<GenerateNewLeaveRequestPage> createState() => _NewLeavePageState();
// }

// class _NewLeavePageState extends State<GenerateNewLeaveRequestPage>
//     with TickerProviderStateMixin {
//   bool _isSubmitting = false;
//   final TextEditingController leaveTypeController = TextEditingController();
//   final TextEditingController fromDateController = TextEditingController();
//   final TextEditingController toDateController = TextEditingController();
//   final TextEditingController reasonController = TextEditingController();

//   final FocusNode causeFocus = FocusNode();
//   final FocusNode fromFocus = FocusNode();
//   final FocusNode toFocus = FocusNode();
//   final FocusNode detailsFocus = FocusNode();

//   FocusNode? activeFocus;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();

//     for (var node in [causeFocus, fromFocus, toFocus, detailsFocus]) {
//       node.addListener(() {
//         setState(() {
//           if (node.hasFocus) {
//             activeFocus = node;
//           } else if (activeFocus == node) {
//             activeFocus = null;
//           }
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     leaveTypeController.dispose();
//     fromDateController.dispose();
//     toDateController.dispose();
//     reasonController.dispose();
//     causeFocus.dispose();
//     fromFocus.dispose();
//     toFocus.dispose();
//     detailsFocus.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate(TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: AppColors.primary, // Using AppColors
//               onPrimary: Colors.white,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = DateFormat('EEE, dd MMM yyyy').format(picked);
//       });
//     }
//   }

//   void _submitForm() {
//     if (_isSubmitting) {
//       return;
//     }

//     if (leaveTypeController.text.isNotEmpty &&
//         fromDateController.text.isNotEmpty) {
//       setState(() {
//         _isSubmitting = true;
//       });

//       context.read<LeaveBloc>().add(
//         SubmitLeaveRequest(
//           status: 'Pending',
//           section: widget.section,
//           studentName: widget.studentName,
//           leaveType: leaveTypeController.text,
//           fromDate: fromDateController.text,
//           toDate: toDateController.text,
//           reason: reasonController.text,
//           currentDate: DateFormat('dd MMM, yyyy').format(DateTime.now()),
//         ),
//       );
//     } else {
//       final size = MediaQuery.of(context).size;
//       final screenWidth = size.width;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'Please fill in both Leave Type and From Date',
//             style: TextStyle(
//               fontSize: screenWidth * 0.035,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           backgroundColor: const Color(0xFFFF3B30),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(screenWidth * 0.03),
//           ),
//           margin: EdgeInsets.all(screenWidth * 0.04),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final screenWidth = size.width;
//     final screenHeight = size.height;
//     final isTablet = screenWidth >= 768;
//     final isLargeTablet = screenWidth > 900;

//     // Fully responsive dimensions
//     final horizontalPadding = screenWidth * (isTablet ? 0.042 : 0.06);
//     final verticalSpacing = screenHeight * (isTablet ? 0.035 : 0.025);
//     final backButtonPadding = screenWidth * 0.04;
//     final iconSize = screenWidth * 0.065;
//     final titleFontSize = screenWidth * (isTablet ? 0.05 : 0.06);
//     final sectionTitleSize = screenWidth * (isTablet ? 0.032 : 0.05);
//     final buttonFontSize = screenWidth * (isTablet ? 0.024 : 0.04);
//     final buttonIconSize = screenWidth * (isTablet ? 0.032 : 0.05);
//     final contentBorderRadius = screenWidth * (isTablet ? 0.026 : 0.035);
//     final headerBarWidth = screenWidth * (isTablet ? 0.006 : 0.01);
//     final headerBarHeight = screenHeight * (isTablet ? 0.035 : 0.03);
//     final buttonVerticalPadding = screenHeight * (isTablet ? 0.025 : 0.02);
//     final buttonHorizontalPadding = screenWidth * (isTablet ? 0.042 : 0.06);
//     final shadowBlurRadius = screenWidth * (isTablet ? 0.032 : 0.05);
//     final shadowOffset = screenHeight * 0.01;
//     final twoColumnSpacing = screenWidth * 0.032;
//     final bottomSpacing = screenHeight * 0.025;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Simple Header with Back Button
//               Padding(
//                 padding: EdgeInsets.all(horizontalPadding),
//                 child: Row(
//                   children: [
//                     NeumorphicButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: NeumorphicStyle(
//                         boxShape: const NeumorphicBoxShape.circle(),
//                         depth: 6,
//                         intensity: 0.8,
//                         shape: NeumorphicShape.flat,
//                         color: Colors.white,
//                       ),
//                       padding: EdgeInsets.all(backButtonPadding),
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: iconSize,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(width: horizontalPadding),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'New Leave Request',
//                             style: TextStyle(
//                               fontSize: titleFontSize,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           SizedBox(height: size.height * 0.005),
//                           Text(
//                             'Fill in the details below',
//                             style: TextStyle(
//                               fontSize: titleFontSize * 0.5,
//                               color: Colors.black54,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Content Section
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   constraints:
//                       isTablet
//                           ? BoxConstraints(maxWidth: screenWidth * 0.7)
//                           : null,
//                   margin:
//                       isTablet && screenWidth > 800
//                           ? EdgeInsets.symmetric(
//                             horizontal: (screenWidth - (screenWidth * 0.7)) / 2,
//                           )
//                           : null,
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.only(
//                       top: verticalSpacing,
//                       left: horizontalPadding,
//                       right: horizontalPadding,
//                       bottom: horizontalPadding,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Form Header
//                         Row(
//                           children: [
//                             Container(
//                               width: headerBarWidth,
//                               height: headerBarHeight,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     AppColors.primary,      // Using AppColors
//                                     AppColors.primaryDark,  // Using AppColors
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(
//                                   headerBarWidth * 0.5,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: horizontalPadding * 0.5),
//                             Text(
//                               'Request Details',
//                               style: TextStyle(
//                                 fontSize: sectionTitleSize,
//                                 fontWeight: FontWeight.bold,
//                                 color: const Color(0xFF111827),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: verticalSpacing),

//                         // Form Fields - Use responsive layout
//                         if (isLargeTablet)
//                           // Two-column layout for large tablets
//                           _buildTwoColumnLayout(
//                             twoColumnSpacing,
//                             verticalSpacing,
//                           )
//                         else
//                           // Single column layout for mobile and small tablets
//                           _buildSingleColumnLayout(verticalSpacing),

//                         SizedBox(height: verticalSpacing * 1.5),

//                         // Submit Button
//                         Container(
//                           width: double.infinity,
//                           constraints:
//                               isTablet
//                                   ? BoxConstraints(maxWidth: screenWidth * 0.4)
//                                   : null,
//                           alignment: isTablet ? Alignment.center : null,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(
//                               contentBorderRadius,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: AppColors.primary.withOpacity(0.3), // Using AppColors
//                                 blurRadius: shadowBlurRadius,
//                                 offset: Offset(0, shadowOffset),
//                               ),
//                             ],
//                           ),
//                           child: BlocConsumer<LeaveBloc, LeaveState>(
//                             listener: (context, state) {
//                               if (state is LeaveSuccess) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'Leave submit successfully!',
//                                       style: TextStyle(
//                                         fontSize: screenWidth * 0.035,
//                                       ),
//                                     ),
//                                     backgroundColor: const Color(0xFF10B981),
//                                     behavior: SnackBarBehavior.floating,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(
//                                         screenWidth * 0.03,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 if (state is LeaveFailure) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Leave not submit!',
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: screenWidth * 0.035,
//                                         ),
//                                       ),
//                                       backgroundColor: Colors.red,
//                                       behavior: SnackBarBehavior.floating,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(
//                                           screenWidth * 0.03,
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                             builder: (context, state) {
//                               return NeumorphicButton(
//                                 onPressed: _submitForm,
//                                 style: NeumorphicStyle(
//                                   color: AppColors.primary, // Using AppColors
//                                   boxShape: NeumorphicBoxShape.roundRect(
//                                     BorderRadius.circular(contentBorderRadius),
//                                   ),
//                                   depth: 4,
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: buttonVerticalPadding,
//                                   horizontal: buttonHorizontalPadding,
//                                 ),
//                                 child: Center(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.send_rounded,
//                                         color: Colors.white,
//                                         size: buttonIconSize,
//                                       ),
//                                       SizedBox(width: screenWidth * 0.025),
//                                       Text(
//                                         'Submit Leave Request',
//                                         style: TextStyle(
//                                           fontSize: buttonFontSize,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),

//                         SizedBox(height: bottomSpacing),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSingleColumnLayout(double verticalSpacing) {
//     return Column(
//       children: [
//         LeaveFormField(
//           label: "Leave Type",
//           icon: Icons.event_note_rounded,
//           controller: leaveTypeController,
//           focusNode: causeFocus,
//           activeFocus: activeFocus,
//           hint: "e.g., Full Day, Half Day, Medical Leave",
//         ),

//         SizedBox(height: verticalSpacing),

//         LeaveFormField(
//           label: "From Date",
//           icon: Icons.calendar_today_rounded,
//           controller: fromDateController,
//           focusNode: fromFocus,
//           activeFocus: activeFocus,
//           readOnly: true,
//           onTap: () => _pickDate(fromDateController),
//           hint: "Select start date",
//         ),

//         SizedBox(height: verticalSpacing),

//         LeaveFormField(
//           label: "To Date",
//           icon: Icons.event_rounded,
//           controller: toDateController,
//           focusNode: toFocus,
//           activeFocus: activeFocus,
//           readOnly: true,
//           onTap: () => _pickDate(toDateController),
//           hint: "Select end date (optional)",
//         ),

//         SizedBox(height: verticalSpacing),

//         LeaveFormField(
//           label: "Reason",
//           icon: Icons.description_rounded,
//           controller: reasonController,
//           focusNode: detailsFocus,
//           activeFocus: activeFocus,
//           maxLines: 4,
//           hint: "Describe the reason for your leave request",
//         ),
//       ],
//     );
//   }

//   Widget _buildTwoColumnLayout(double columnSpacing, double verticalSpacing) {
//     return Column(
//       children: [
//         // First row - Leave Type and From Date
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: LeaveFormField(
//                 label: "Leave Type",
//                 icon: Icons.event_note_rounded,
//                 controller: leaveTypeController,
//                 focusNode: causeFocus,
//                 activeFocus: activeFocus,
//                 hint: "e.g., Full Day, Half Day",
//               ),
//             ),
//             SizedBox(width: columnSpacing),
//             Expanded(
//               child: LeaveFormField(
//                 label: "From Date",
//                 icon: Icons.calendar_today_rounded,
//                 controller: fromDateController,
//                 focusNode: fromFocus,
//                 activeFocus: activeFocus,
//                 readOnly: true,
//                 onTap: () => _pickDate(fromDateController),
//                 hint: "Select start date",
//               ),
//             ),
//           ],
//         ),

//         SizedBox(height: verticalSpacing),

//         // Second row - To Date only (spans half width)
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: LeaveFormField(
//                 label: "To Date",
//                 icon: Icons.event_rounded,
//                 controller: toDateController,
//                 focusNode: toFocus,
//                 activeFocus: activeFocus,
//                 readOnly: true,
//                 onTap: () => _pickDate(toDateController),
//                 hint: "Select end date (optional)",
//               ),
//             ),
//             const Expanded(child: SizedBox()), // Empty space
//           ],
//         ),

//         SizedBox(height: verticalSpacing),

//         // Third row - Reason (full width)
//         LeaveFormField(
//           label: "Reason",
//           icon: Icons.description_rounded,
//           controller: reasonController,
//           focusNode: detailsFocus,
//           activeFocus: activeFocus,
//           maxLines: 4,
//           hint: "Describe the reason for your leave request",
//         ),
//       ],
//     );
//   }
// }

// ══════════════════════════════════════════════════════════════════════════════
// REDESIGNED: GenerateNewLeaveRequestPage
// Designer note: Editorial facelift — zero logic / Firebase / BLoC changes.
// Philosophy: "Warm stone editorial" — _Ink tokens, DM Serif Display,
//             newspaper rules, cream surfaces, dark-slab submit CTA.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_foam_feild.dart';
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
  static const sand = Color(0xFFEDE9E4);
  static const sage = Color(0xFFE4EDE7);
}

// ══════════════════════════════════════════════════════════════════════════════
// PAGE — logic preserved 100%
// ══════════════════════════════════════════════════════════════════════════════

class GenerateNewLeaveRequestPage extends StatefulWidget {
  final String section;
  final String studentName;
  const GenerateNewLeaveRequestPage({
    required this.section,
    required this.studentName,
    super.key,
  });

  @override
  State<GenerateNewLeaveRequestPage> createState() => _NewLeavePageState();
}

class _NewLeavePageState extends State<GenerateNewLeaveRequestPage>
    with TickerProviderStateMixin {
  // ── Logic: preserved exactly ───────────────────────────────────────────────
  bool _isSubmitting = false;
  final TextEditingController leaveTypeController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final FocusNode causeFocus = FocusNode();
  final FocusNode fromFocus = FocusNode();
  final FocusNode toFocus = FocusNode();
  final FocusNode detailsFocus = FocusNode();

  FocusNode? activeFocus;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    for (var node in [causeFocus, fromFocus, toFocus, detailsFocus]) {
      node.addListener(() {
        setState(() {
          if (node.hasFocus) {
            activeFocus = node;
          } else if (activeFocus == node) {
            activeFocus = null;
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    leaveTypeController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    causeFocus.dispose();
    fromFocus.dispose();
    toFocus.dispose();
    detailsFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _Ink.inkDeep,
              onPrimary: Color(0xFFF9F7F4),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('EEE, dd MMM yyyy').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_isSubmitting) return;

    if (leaveTypeController.text.isNotEmpty &&
        fromDateController.text.isNotEmpty) {
      setState(() => _isSubmitting = true);

      context.read<LeaveBloc>().add(
        SubmitLeaveRequest(
          status: 'Pending',
          section: widget.section,
          studentName: widget.studentName,
          leaveType: leaveTypeController.text,
          fromDate: fromDateController.text,
          toDate: toDateController.text,
          reason: reasonController.text,
          currentDate: DateFormat('dd MMM, yyyy').format(DateTime.now()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both Leave Type and From Date'),
          backgroundColor: const Color(0xFFFF3B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
  // ── End preserved logic ────────────────────────────────────────────────────

  // ── Date string helper ─────────────────────────────────────────────────────
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

    final isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: _Ink.pageBg,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Editorial header ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: _EditorialFormHeader(
                  dateString: _dateString,
                  onBack: () => Navigator.pop(context),
                ),
              ),

              // ── Section label ─────────────────────────────────────────────
              SliverToBoxAdapter(child: _SectionLabel('Request details')),

              // ── Form fields ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      isTablet
                          ? _buildTwoColumnLayout()
                          : _buildSingleColumnLayout(),
                ),
              ),

              // ── Submit CTA ────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
                  child: BlocConsumer<LeaveBloc, LeaveState>(
                    listener: (context, state) {
                      if (state is LeaveSuccess) {
                        // Reset loading state immediately
                        setState(() => _isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Leave submitted successfully!',
                            ),
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                        // Return true so the list screen refreshes
                        Navigator.pop(context, true);
                      } else if (state is LeaveFailure) {
                        // Reset loading so user can retry
                        setState(() => _isSubmitting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Could not submit leave request.',
                            ),
                            backgroundColor: const Color(0xFFFF3B30),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return _SubmitButton(
                        isSubmitting: _isSubmitting || state is LeaveLoading,
                        onPressed: _submitForm,
                      );
                    },
                  ),
                ),
              ),

              // ── Footer ────────────────────────────────────────────────────
              SliverToBoxAdapter(child: _Footer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleColumnLayout() {
    return Column(
      children: [
        _EditorialFormField(
          label: 'Leave Type',
          sublabel: 'Full Day, Half Day, Medical Leave…',
          icon: Icons.event_note_rounded,
          child: LeaveFormField(
            label: 'Leave Type',
            icon: Icons.event_note_rounded,
            controller: leaveTypeController,
            focusNode: causeFocus,
            activeFocus: activeFocus,
            hint: 'e.g., Full Day, Half Day, Medical Leave',
          ),
        ),
        const SizedBox(height: 12),
        _EditorialFormField(
          label: 'From Date',
          sublabel: 'Start of your leave period',
          icon: Icons.calendar_today_rounded,
          child: LeaveFormField(
            label: 'From Date',
            icon: Icons.calendar_today_rounded,
            controller: fromDateController,
            focusNode: fromFocus,
            activeFocus: activeFocus,
            readOnly: true,
            onTap: () => _pickDate(fromDateController),
            hint: 'Select start date',
          ),
        ),
        const SizedBox(height: 12),
        _EditorialFormField(
          label: 'To Date',
          sublabel: 'Optional — leave blank for single day',
          icon: Icons.event_rounded,
          child: LeaveFormField(
            label: 'To Date',
            icon: Icons.event_rounded,
            controller: toDateController,
            focusNode: toFocus,
            activeFocus: activeFocus,
            readOnly: true,
            onTap: () => _pickDate(toDateController),
            hint: 'Select end date (optional)',
          ),
        ),
        const SizedBox(height: 12),
        _EditorialFormField(
          label: 'Reason',
          sublabel: 'Describe your situation clearly',
          icon: Icons.description_rounded,
          child: LeaveFormField(
            label: 'Reason',
            icon: Icons.description_rounded,
            controller: reasonController,
            focusNode: detailsFocus,
            activeFocus: activeFocus,
            maxLines: 4,
            hint: 'Describe the reason for your leave request',
          ),
        ),
      ],
    );
  }

  Widget _buildTwoColumnLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _EditorialFormField(
                label: 'Leave Type',
                sublabel: 'Full Day, Half Day…',
                icon: Icons.event_note_rounded,
                child: LeaveFormField(
                  label: 'Leave Type',
                  icon: Icons.event_note_rounded,
                  controller: leaveTypeController,
                  focusNode: causeFocus,
                  activeFocus: activeFocus,
                  hint: 'e.g., Full Day, Half Day',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _EditorialFormField(
                label: 'From Date',
                sublabel: 'Start of leave',
                icon: Icons.calendar_today_rounded,
                child: LeaveFormField(
                  label: 'From Date',
                  icon: Icons.calendar_today_rounded,
                  controller: fromDateController,
                  focusNode: fromFocus,
                  activeFocus: activeFocus,
                  readOnly: true,
                  onTap: () => _pickDate(fromDateController),
                  hint: 'Select start date',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _EditorialFormField(
                label: 'To Date',
                sublabel: 'Optional',
                icon: Icons.event_rounded,
                child: LeaveFormField(
                  label: 'To Date',
                  icon: Icons.event_rounded,
                  controller: toDateController,
                  focusNode: toFocus,
                  activeFocus: activeFocus,
                  readOnly: true,
                  onTap: () => _pickDate(toDateController),
                  hint: 'Select end date (optional)',
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        const SizedBox(height: 12),
        _EditorialFormField(
          label: 'Reason',
          sublabel: 'Describe your situation',
          icon: Icons.description_rounded,
          child: LeaveFormField(
            label: 'Reason',
            icon: Icons.description_rounded,
            controller: reasonController,
            focusNode: detailsFocus,
            activeFocus: activeFocus,
            maxLines: 4,
            hint: 'Describe the reason for your leave request',
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL FORM HEADER
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialFormHeader extends StatelessWidget {
  final String dateString;
  final VoidCallback onBack;
  const _EditorialFormHeader({required this.dateString, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dateline row ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  _TagPill('New Request'),
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

        // ── Hairline ───────────────────────────────────────────────────────
        const Divider(height: 1, thickness: 0.8, color: _Ink.divider),

        // ── DM Serif headline ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New application',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.4,
                  color: _Ink.inkSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Leave\nRequest',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 44,
                  fontWeight: FontWeight.w400,
                  color: _Ink.inkDeep,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '"A clear request is halfway to approval."',
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

        // ── Double editorial rule ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Container(height: 2.5, color: _Ink.inkDeep),
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(child: Container(height: 0.8, color: _Ink.divider)),
                  const SizedBox(width: 6),
                  Expanded(child: Container(height: 0.8, color: _Ink.divider)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
      ],
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

// ══════════════════════════════════════════════════════════════════════════════
// SECTION LABEL
// ══════════════════════════════════════════════════════════════════════════════

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500,
          color: _Ink.inkSoft,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// EDITORIAL FORM FIELD WRAPPER — wraps existing LeaveFormField widget
// ══════════════════════════════════════════════════════════════════════════════

class _EditorialFormField extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final Widget child;

  const _EditorialFormField({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Ink.sand,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _Ink.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Field label row ──────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _Ink.inkDeep.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 12, color: _Ink.inkMid),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _Ink.inkDeep,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: const TextStyle(fontSize: 10, color: _Ink.inkFaint),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          Container(height: 0.8, color: _Ink.divider.withOpacity(0.6)),
          const SizedBox(height: 10),

          // ── Actual form field (logic owned by LeaveFormField) ────────────
          child,
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SUBMIT BUTTON — dark inkDeep slab, DM Serif italic label
// ══════════════════════════════════════════════════════════════════════════════

class _SubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;
  const _SubmitButton({required this.isSubmitting, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isLoading = isSubmitting;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        color: isLoading ? _Ink.inkDeep.withOpacity(0.7) : _Ink.inkDeep,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _Ink.inkDeep.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFF9F7F4),
                        ),
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send_rounded,
                          size: 17,
                          color: Color(0xFFF9F7F4),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Submit Leave Request',
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xFFF9F7F4),
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FOOTER — masthead colophon
// ══════════════════════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(height: 1, thickness: 0.8, color: _Ink.divider),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'CAS LEARNING SYSTEM',
                style: TextStyle(
                  fontSize: 9,
                  letterSpacing: 1.4,
                  color: _Ink.inkFaint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Leave Module · v1.0',
                style: TextStyle(fontSize: 10, color: _Ink.inkFaint),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
