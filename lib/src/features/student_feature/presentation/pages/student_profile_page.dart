import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/Student_feature_event.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_bloc.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/bloc/student_feature_state.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/presentation/pages/StudentDetailPage.dart';

class StudentProfilePage extends StatefulWidget {
  final String id;
  const StudentProfilePage({super.key, required this.id});

  @override
  StudentProfilePageState createState() => StudentProfilePageState();
}

class StudentProfilePageState extends State<StudentProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFlipped = false;

  // Neomorphic color palette
  final Color _backgroundColor = Color(0xFFE6F3F7);
  final Color _shadowColor = Color(0xFFBED7DC);
  final Color _highlightColor = Color(0xFFFFFFFF);
  final Color _accentColor = Color(0xFF00BCD4);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Media query for responsive design
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;
            bool isTablet = screenWidth > 600;

            return Column(
              children: [
                // Header
                _buildHeader(isTablet),

                // Profile Card Container
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 40.0 : 20.0,
                      vertical: 20.0,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 400 : double.infinity,
                          maxHeight: screenHeight * 0.8,
                        ),
                        child: GestureDetector(
                          onTap: _flipCard,
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform(
                                alignment: Alignment.center,
                                transform:
                                    Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateY(_animation.value * 3.14159),
                                child:
                                    _animation.value < 0.5
                                        ? _buildFrontCard(isTablet, screenWidth)
                                        : Transform(
                                          alignment: Alignment.center,
                                          transform:
                                              Matrix4.identity()
                                                ..rotateY(3.14159),
                                          child: _buildBackCard(
                                            isTablet,
                                            screenWidth,
                                          ),
                                        ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 30.0 : 20.0,
        vertical: 15.0,
      ),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _shadowColor,
            offset: Offset(8, 8),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: _highlightColor,
            offset: Offset(-8, -8),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNeomorphicButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF6B7280),
              size: isTablet ? 28 : 24,
            ),
            onPressed: () {
              // Navigate back
              Navigator.pop(context);
            },
            size: isTablet ? 56 : 48,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 56 : 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildNeomorphicContainer({
    required Widget child,
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool isPressed = false,
    bool isInset = false,
  }) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isInset
                ? [
                  BoxShadow(
                    color: _shadowColor,
                    offset: Offset(4, 4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _highlightColor,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
                : isPressed
                ? [
                  BoxShadow(
                    color: _shadowColor.withOpacity(0.5),
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _highlightColor.withOpacity(0.5),
                    offset: Offset(-2, -2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ]
                : [
                  BoxShadow(
                    color: _shadowColor,
                    offset: Offset(8, 8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: _highlightColor,
                    offset: Offset(-8, -8),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
      ),
      child: child,
    );
  }

  Widget _buildNeomorphicButton({
    required Widget child,
    required VoidCallback onPressed,
    double size = 48,
    bool isPressed = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: _buildNeomorphicContainer(
        width: size,
        height: size,
        isPressed: isPressed,
        child: Center(child: child),
      ),
    );
  }

  Widget _buildFrontCard(bool isTablet, double screenWidth) {
    return BlocConsumer<StudentFeatureBloc, StudentFeatureState>(
      listener: (context, state) {
        if (state is GroupStudentsDatafetched) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StudentDetailPage(
                  student: StudentEntityClass(
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
                  ),
                );
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return _buildNeomorphicContainer(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Picture Section
              Container(
                padding: EdgeInsets.all(isTablet ? 40.0 : 30.0),
                child: Column(
                  children: [
                    // Profile Picture with neomorphic effect
                    _buildNeomorphicContainer(
                      width: isTablet ? 120 : 100,
                      height: isTablet ? 120 : 100,
                      isInset: true,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _shadowColor,
                              offset: Offset(4, 4),
                              blurRadius: 8,
                            ),
                            BoxShadow(
                              color: _highlightColor,
                              offset: Offset(-4, -4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile_image.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: _backgroundColor,
                                child: Icon(
                                  Icons.person,
                                  size: isTablet ? 60 : 50,
                                  color: Color(0xFF6B7280),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 24 : 20),

                    // Name
                    Text(
                      'Mujeeb',
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    SizedBox(height: isTablet ? 12 : 8),

                    // Email
                    Text(
                      'admin@admin.com',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32.0 : 24.0,
                    vertical: isTablet ? 16.0 : 12.0,
                  ),
                  child: Column(
                    children: [
                      _buildNeomorphicMenuItem(
                        Icons.person_outline,
                        'User Details',
                        isTablet,
                        onTap: () {
                          context.read<StudentFeatureBloc>().add(
                            FetchGroupStudentsEvent(id: widget.id),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      _buildNeomorphicMenuItem(
                        Icons.settings_outlined,
                        'Profile Settings',
                        isTablet,
                        onTap: () {},
                      ),
                      SizedBox(height: 16),
                      _buildNeomorphicMenuItem(
                        Icons.lock_outline,
                        'Change Password',
                        isTablet,
                        onTap: () {},
                      ),
                      SizedBox(height: 16),
                      _buildNeomorphicMenuItem(
                        Icons.logout_outlined,
                        'Logout',
                        isTablet,
                        isLogout: true,
                        onTap: () {},
                      ),

                      SizedBox(height: isTablet ? 24 : 16),

                      // Flip indicator
                      _buildNeomorphicContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.flip, size: 16, color: _accentColor),
                            SizedBox(width: 8),
                            Text(
                              'Tap to flip',
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackCard(bool isTablet, double screenWidth) {
    return _buildNeomorphicContainer(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNeomorphicContainer(
            width: isTablet ? 100 : 80,
            height: isTablet ? 100 : 80,
            child: Icon(
              Icons.info_outline,
              size: isTablet ? 50 : 40,
              color: _accentColor,
            ),
          ),

          SizedBox(height: isTablet ? 24 : 20),

          Text(
            'Additional Information',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),

          SizedBox(height: isTablet ? 16 : 12),

          Text(
            'This is the back side of the profile card. You can add additional user information, statistics, or any other relevant details here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),

          SizedBox(height: isTablet ? 32 : 24),

          // Some stats with neomorphic containers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNeomorphicStatItem('120', 'Posts', isTablet),
              _buildNeomorphicStatItem('1.5K', 'Followers', isTablet),
              _buildNeomorphicStatItem('180', 'Following', isTablet),
            ],
          ),

          SizedBox(height: isTablet ? 32 : 24),

          // Flip back indicator
          _buildNeomorphicContainer(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flip, size: 16, color: _accentColor),
                SizedBox(width: 8),
                Text(
                  'Tap to flip back',
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeomorphicMenuItem(
    IconData icon,
    String title,
    bool isTablet, {
    bool isLogout = false,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: _buildNeomorphicContainer(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16.0 : 12.0,
          horizontal: 16.0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: isTablet ? 28 : 24,
              color: isLogout ? Colors.red.shade400 : Color(0xFF6B7280),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red.shade400 : Color(0xFF1F2937),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: isTablet ? 20 : 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeomorphicStatItem(String value, String label, bool isTablet) {
    return _buildNeomorphicContainer(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12,
        vertical: isTablet ? 16 : 12,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: _accentColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
