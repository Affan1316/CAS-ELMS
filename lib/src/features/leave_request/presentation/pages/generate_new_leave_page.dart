import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_foam_feild.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class GenerateNewLeaveRequestPage extends StatefulWidget {
  final String section;
  final String studentName;
  const GenerateNewLeaveRequestPage({
    required this.section,
    required this.studentName,
    super.key});
    
  @override
  State<GenerateNewLeaveRequestPage> createState() => _NewLeavePageState();
}

class _NewLeavePageState extends State<GenerateNewLeaveRequestPage>
    with TickerProviderStateMixin {
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
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
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
  
  if (_isSubmitting) {
    return;
  }

  if (leaveTypeController.text.isNotEmpty &&
      fromDateController.text.isNotEmpty) {
    
    setState(() {
      _isSubmitting = true;
    });

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
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please fill in both Leave Type and From Date',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        margin: EdgeInsets.all(screenWidth * 0.04),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isTablet = screenWidth >= 768;
    final isLargeTablet = screenWidth > 900;

    // Fully responsive dimensions
    final headerHeight = screenHeight * (isTablet ? 0.25 : 0.22);
    final horizontalPadding = screenWidth * (isTablet ? 0.042 : 0.06);
    final verticalSpacing = screenHeight * (isTablet ? 0.035 : 0.025);
    final headerTopPadding = screenHeight * 0.025;
    final backButtonSize = screenWidth * (isTablet ? 0.035 : 0.05);
    final backButtonPadding = screenWidth * (isTablet ? 0.021 : 0.03);
    final titleFontSize = screenWidth * (isTablet ? 0.04 : 0.065);
    final subtitleFontSize = screenWidth * (isTablet ? 0.022 : 0.038);
    final sectionTitleSize = screenWidth * (isTablet ? 0.032 : 0.05);
    final buttonFontSize = screenWidth * (isTablet ? 0.024 : 0.04);
    final buttonIconSize = screenWidth * (isTablet ? 0.032 : 0.05);
    final borderRadius = screenWidth * (isTablet ? 0.042 : 0.07);
    final contentBorderRadius = screenWidth * (isTablet ? 0.026 : 0.035);
    final headerBarWidth = screenWidth * (isTablet ? 0.006 : 0.01);
    final headerBarHeight = screenHeight * (isTablet ? 0.035 : 0.03);
    final contentTopSpacing = screenHeight * (isTablet ? 0.05 : 0.04);
    final formTopSpacing = screenHeight * 0.02;
    final buttonVerticalPadding = screenHeight * (isTablet ? 0.025 : 0.02);
    final buttonHorizontalPadding = screenWidth * (isTablet ? 0.042 : 0.06);
    final shadowBlurRadius = screenWidth * (isTablet ? 0.032 : 0.05);
    final shadowOffset = screenHeight * 0.01;
    final contentTranslateY = -(screenHeight * (isTablet ? 0.04 : 0.035));
    final twoColumnSpacing = screenWidth * 0.032;
    final bottomSpacing = screenHeight * 0.025;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Header Section
            Container(
              height: headerHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NeumorphicButton(
                            onPressed: () => Navigator.pop(context),
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: const NeumorphicBoxShape.circle(),
                              depth: 2,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            padding: EdgeInsets.all(backButtonPadding),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: backButtonSize,
                            ),
                          ),
                          SizedBox(width: horizontalPadding * 0.7),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Leave Request',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  'Fill in the details below',
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Section
            Expanded(
              child: Container(
                transform: Matrix4.translationValues(0, contentTranslateY, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  constraints: isTablet 
                      ? BoxConstraints(maxWidth: screenWidth * 0.7) 
                      : null,
                  margin: isTablet && screenWidth > 800
                      ? EdgeInsets.symmetric(
                          horizontal: (screenWidth - (screenWidth * 0.7)) / 2,
                        )
                      : null,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: contentTopSpacing,
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Form Header
                        Row(
                          children: [
                            Container(
                              width: headerBarWidth,
                              height: headerBarHeight,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(
                                  headerBarWidth * 0.5,
                                ),
                              ),
                            ),
                            SizedBox(width: horizontalPadding * 0.5),
                            Text(
                              'Request Details',
                              style: TextStyle(
                                fontSize: sectionTitleSize,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C1C1E),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: verticalSpacing),

                        // Form Fields - Use responsive layout
                        if (isLargeTablet)
                          // Two-column layout for large tablets
                          _buildTwoColumnLayout(twoColumnSpacing, verticalSpacing)
                        else
                          // Single column layout for mobile and small tablets
                          _buildSingleColumnLayout(verticalSpacing),

                        SizedBox(height: verticalSpacing * 1.5),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          constraints: isTablet
                              ? BoxConstraints(maxWidth: screenWidth * 0.4)
                              : null,
                          alignment: isTablet ? Alignment.center : null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(contentBorderRadius),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.3),
                                blurRadius: shadowBlurRadius,
                                offset: Offset(0, shadowOffset),
                              ),
                            ],
                          ),
                          child: BlocConsumer<LeaveBloc, LeaveState>(
                            listener: (context, state) {
                              if (state is LeaveSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Leave submit successfully!',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    backgroundColor: const Color(0xFF10B981),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                if (state is LeaveFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Leave not submit!',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            builder: (context, state) {
                              return NeumorphicButton(
                                onPressed: _submitForm,
                                style: NeumorphicStyle(
                                  color: const Color(0xFF6366F1),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(contentBorderRadius),
                                  ),
                                  depth: 4,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: buttonVerticalPadding,
                                  horizontal: buttonHorizontalPadding,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: buttonIconSize,
                                      ),
                                      SizedBox(width: screenWidth * 0.025),
                                      Text(
                                        'Submit Leave Request',
                                        style: TextStyle(
                                          fontSize: buttonFontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: bottomSpacing),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleColumnLayout(double verticalSpacing) {
    return Column(
      children: [
        LeaveFormField(
          label: "Leave Type",
          icon: Icons.event_note_rounded,
          controller: leaveTypeController,
          focusNode: causeFocus,
          activeFocus: activeFocus,
          hint: "e.g., Full Day, Half Day, Medical Leave",
        ),

        SizedBox(height: verticalSpacing),

        LeaveFormField(
          label: "From Date",
          icon: Icons.calendar_today_rounded,
          controller: fromDateController,
          focusNode: fromFocus,
          activeFocus: activeFocus,
          readOnly: true,
          onTap: () => _pickDate(fromDateController),
          hint: "Select start date",
        ),

        SizedBox(height: verticalSpacing),

        LeaveFormField(
          label: "To Date",
          icon: Icons.event_rounded,
          controller: toDateController,
          focusNode: toFocus,
          activeFocus: activeFocus,
          readOnly: true,
          onTap: () => _pickDate(toDateController),
          hint: "Select end date (optional)",
        ),

        SizedBox(height: verticalSpacing),

        LeaveFormField(
          label: "Reason",
          icon: Icons.description_rounded,
          controller: reasonController,
          focusNode: detailsFocus,
          activeFocus: activeFocus,
          maxLines: 4,
          hint: "Describe the reason for your leave request",
        ),
      ],
    );
  }

  Widget _buildTwoColumnLayout(double columnSpacing, double verticalSpacing) {
    return Column(
      children: [
        // First row - Leave Type and From Date
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LeaveFormField(
                label: "Leave Type",
                icon: Icons.event_note_rounded,
                controller: leaveTypeController,
                focusNode: causeFocus,
                activeFocus: activeFocus,
                hint: "e.g., Full Day, Half Day",
              ),
            ),
            SizedBox(width: columnSpacing),
            Expanded(
              child: LeaveFormField(
                label: "From Date",
                icon: Icons.calendar_today_rounded,
                controller: fromDateController,
                focusNode: fromFocus,
                activeFocus: activeFocus,
                readOnly: true,
                onTap: () => _pickDate(fromDateController),
                hint: "Select start date",
              ),
            ),
          ],
        ),

        SizedBox(height: verticalSpacing),

        // Second row - To Date only (spans half width)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LeaveFormField(
                label: "To Date",
                icon: Icons.event_rounded,
                controller: toDateController,
                focusNode: toFocus,
                activeFocus: activeFocus,
                readOnly: true,
                onTap: () => _pickDate(toDateController),
                hint: "Select end date (optional)",
              ),
            ),
            const Expanded(child: SizedBox()), // Empty space
          ],
        ),

        SizedBox(height: verticalSpacing),

        // Third row - Reason (full width)
        LeaveFormField(
          label: "Reason",
          icon: Icons.description_rounded,
          controller: reasonController,
          focusNode: detailsFocus,
          activeFocus: activeFocus,
          maxLines: 4,
          hint: "Describe the reason for your leave request",
        ),
      ],
    );
  }
}