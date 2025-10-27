import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/bloc/leave_bloc.dart';
import 'package:flutter_cas_app_main/src/features/leave_request/presentation/widgets/leave_foam_feild.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';

class GenerateNewLeaveRequestPage extends StatefulWidget {
  final String groupName;
  final String studentName;
  const GenerateNewLeaveRequestPage({
    required this.groupName,
    required this.studentName,
    super.key});
    
  @override
  State<GenerateNewLeaveRequestPage> createState() => _NewLeavePageState();
}

class _NewLeavePageState extends State<GenerateNewLeaveRequestPage>
    with TickerProviderStateMixin {
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
    if (leaveTypeController.text.isNotEmpty &&
        fromDateController.text.isNotEmpty) {
      context.read<LeaveBloc>().add(
        SubmitLeaveRequest(
          status: 'Pending',
          section: widget.groupName,
          studentName: widget.studentName,
          leaveType: leaveTypeController.text,
          fromDate: fromDateController.text,
          toDate: toDateController.text,
          reason: reasonController.text,
          currentDate: DateFormat('dd MMM, yyyy').format(DateTime.now()),
        ),
      );
    } else {
      final screenWidth = MediaQuery.of(context).size.width;
      final isTablet = screenWidth >= 768;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in both Cause and From Date',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFFFF3B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          margin: EdgeInsets.all(isTablet ? 20 : 16),
        ),
      );
    }
  }

  double _getResponsiveFontSize(
    double screenWidth,
    double mobile,
    double tablet,
  ) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  double _getResponsiveSpacing(
    double screenWidth,
    double mobile,
    double tablet,
  ) {
    if (screenWidth >= 768) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 768;
    final isLandscape = screenWidth > screenHeight;
    final safePadding = MediaQuery.of(context).padding;

    // Responsive dimensions
    final headerHeight = isTablet ? 220.0 : 180.0;
    final horizontalPadding = _getResponsiveSpacing(screenWidth, 24, 32);
    final verticalSpacing = _getResponsiveSpacing(screenWidth, 20, 28);

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
                            padding: EdgeInsets.all(isTablet ? 16 : 12),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: isTablet ? 24 : 20,
                            ),
                          ),
                          SizedBox(width: isTablet ? 20 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Leave Request',
                                  style: TextStyle(
                                    fontSize: _getResponsiveFontSize(
                                      screenWidth,
                                      26,
                                      30,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: isTablet ? 6 : 4),
                                Text(
                                  'Fill in the details below',
                                  style: TextStyle(
                                    fontSize: _getResponsiveFontSize(
                                      screenWidth,
                                      15,
                                      17,
                                    ),
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
                transform: Matrix4.translationValues(
                  0,
                  isTablet ? -32 : -28,
                  0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isTablet ? 32 : 28),
                    topRight: Radius.circular(isTablet ? 32 : 28),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  constraints:
                      isTablet ? const BoxConstraints(maxWidth: 800) : null,
                  margin:
                      isTablet && screenWidth > 800
                          ? EdgeInsets.symmetric(
                            horizontal: (screenWidth - 800) / 2,
                          )
                          : null,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: isTablet ? 40 : 32,
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
                              width: isTablet ? 5 : 4,
                              height: isTablet ? 28 : 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(width: isTablet ? 16 : 12),
                            Text(
                              'Request Details',
                              style: TextStyle(
                                fontSize: _getResponsiveFontSize(
                                  screenWidth,
                                  20,
                                  24,
                                ),
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1C1C1E),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: verticalSpacing),

                        // Form Fields - Use responsive layout
                        if (isTablet && screenWidth > 900)
                          // Two-column layout for large tablets
                          _buildTwoColumnLayout()
                        else
                          // Single column layout for mobile and small tablets
                          _buildSingleColumnLayout(),

                        SizedBox(height: isTablet ? 40 : 32),

                        // Submit Button
                        Container(
                          width: double.infinity,
                          constraints:
                              isTablet
                                  ? const BoxConstraints(maxWidth: 400)
                                  : null,
                          alignment: isTablet ? Alignment.center : null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              isTablet ? 20 : 16,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.3),
                                blurRadius: isTablet ? 24 : 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: BlocConsumer<LeaveBloc, LeaveState>(
                            listener: (context, state) {
                              if (state is LeaveSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Leave submit successfully!',
                                    ),
                                    backgroundColor: const Color(0xFF10B981),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              } else {
                                if (state is LeaveFailure) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Leave not submit!',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                                    BorderRadius.circular(isTablet ? 20 : 16),
                                  ),
                                  depth: 4,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 20 : 16,
                                  horizontal: isTablet ? 32 : 24,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: isTablet ? 24 : 20,
                                      ),
                                      SizedBox(width: isTablet ? 12 : 8),
                                      Text(
                                        'Submit Leave Request',
                                        style: TextStyle(
                                          fontSize: _getResponsiveFontSize(
                                            screenWidth,
                                            16,
                                            18,
                                          ),
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

                        SizedBox(height: verticalSpacing),
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

  Widget _buildSingleColumnLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final verticalSpacing = _getResponsiveSpacing(screenWidth, 20, 28);

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

  Widget _buildTwoColumnLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final verticalSpacing = _getResponsiveSpacing(screenWidth, 20, 28);

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
            const SizedBox(width: 24),
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
