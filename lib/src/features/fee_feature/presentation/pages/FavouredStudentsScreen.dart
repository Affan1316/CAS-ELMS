import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/FavouredStudentEntity%20.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:intl/intl.dart';

class FavouredStudentsScreen extends StatefulWidget {
  const FavouredStudentsScreen({super.key});

  @override
  State<FavouredStudentsScreen> createState() => _FavouredStudentsScreenState();
}

class _FavouredStudentsScreenState extends State<FavouredStudentsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String? _expandedGroupId;

  // Light Neomorphic colors - softer and more subtle
  static const Color _backgroundColor = Color(0xFFECF0F3);
  static const Color _shadowDark = Color(0xFFD1D9E6);
  static const Color _shadowLight = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    context.read<FeeAdminBloc>().add(const ReadFavouredStudentsEvent());
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: ResponsivePadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Neomorphic Header
              _buildNeomorphicHeader(context),
              const SizedBox(height: 24),

              // Main Content
              Expanded(
                child: BlocBuilder<FeeAdminBloc, FeeAdminState>(
                  builder: (context, state) {
                    if (state is FavouredStudentsLoadingState) {
                      return _buildLoadingState();
                    }

                    if (state is FavouredStudentsErrorState) {
                      return _buildErrorState(state);
                    }

                    if (state is FavouredStudentsLoadedState) {
                      if (state.favouredStudents.isEmpty) {
                        return _buildEmptyState();
                      }

                      return _buildLoadedContent(
                        state,
                        currencyFormat,
                        isTablet,
                      );
                    }

                    return const Center(child: Text('Unknown state'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeomorphicHeader(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: Row(
        children: [
          // Back Button
          _buildNeomorphicButton(
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.black,
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),

          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Favoured Students',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage student fee concessions',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Refresh Button
          _buildNeomorphicButton(
            child: const Icon(
              Icons.refresh_rounded,
              size: 22,
              color: Colors.black,
            ),
            onTap: () {
              context.read<FeeAdminBloc>().add(
                const ReadFavouredStudentsEvent(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.refresh, color: Colors.white, size: 20),
                      SizedBox(width: 12),
                      Text('Refreshing data...'),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF2C3E50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeomorphicButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: _shadowDark, offset: Offset(3, 3), blurRadius: 6),
            BoxShadow(
              color: _shadowLight,
              offset: Offset(-3, -3),
              blurRadius: 6,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  // Raised effect - for cards and containers (lighter shadows)
  Widget _buildNeomorphicContainer({
    required Widget child,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: _shadowDark, offset: Offset(6, 6), blurRadius: 12),
          BoxShadow(
            color: _shadowLight,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
        ],
      ),
      child: child,
    );
  }

  // Pressed/Inset effect - for inputs (lighter version)
  Widget _buildNeomorphicInset({required Widget child, EdgeInsets? padding}) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _shadowDark.withOpacity(0.15),
            _backgroundColor,
            _shadowLight.withOpacity(0.15),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(color: _shadowDark.withOpacity(0.2), width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: _shadowDark.withOpacity(0.15),
              offset: const Offset(2, 2),
              blurRadius: 4,
              spreadRadius: -1,
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNeomorphicContainer(
            padding: const EdgeInsets.all(24),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Loading favoured students...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(FavouredStudentsErrorState state) {
    return Center(
      child: _buildNeomorphicContainer(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    offset: const Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                context.read<FeeAdminBloc>().add(
                  const ReadFavouredStudentsEvent(),
                );
              },
              child: _buildNeomorphicContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded, color: Color(0xFF3B82F6)),
                    SizedBox(width: 8),
                    Text(
                      'Try Again',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: _buildNeomorphicContainer(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _backgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    offset: const Offset(3, 3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    offset: const Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(
                Icons.school_outlined,
                size: 64,
                color: Colors.blue.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Favoured Students Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Students with fee concessions will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(
    FavouredStudentsLoadedState state,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FadeTransition(
        opacity: _animationController,
        child: Column(
          children: [
            // Neomorphic Filter
            _buildNeomorphicFilter(state, context),
            const SizedBox(height: 24),

            // All three cards vertical and equal size
            _buildNeomorphicSummaryCards(state, currencyFormat),
            const SizedBox(height: 24),

            // Students List
            _buildGroupedStudentsList(state, currencyFormat, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildNeomorphicFilter(
    FavouredStudentsLoadedState state,
    BuildContext context,
  ) {
    final groups = state.groupedByGroup.keys.toList()..sort();

    return _buildNeomorphicContainer(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: _shadowDark,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: _shadowLight,
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.filter_list_rounded,
              color: Color(0xFF3B82F6),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Filter by Group',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildNeomorphicInset(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: state.selectedGroupId,
                  isExpanded: true,
                  hint: const Text(
                    'All Groups',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Groups'),
                    ),
                    ...groups.map((groupId) {
                      final count = state.groupedByGroup[groupId]!.length;
                      return DropdownMenuItem<String?>(
                        value: groupId,
                        child: Row(
                          children: [
                            Text(groupId),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  onChanged: (String? newGroupId) {
                    context.read<FeeAdminBloc>().add(
                      FilterFavouredStudentsByGroupEvent(groupId: newGroupId),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeomorphicSummaryCards(
    FavouredStudentsLoadedState state,
    NumberFormat currencyFormat,
  ) {
    List<FavouredStudentEntity> displayedStudents;

    if (state.selectedGroupId == null) {
      displayedStudents = state.favouredStudents;
    } else {
      displayedStudents = state.groupedByGroup[state.selectedGroupId] ?? [];
    }

    final totalStudents = displayedStudents.length;
    final totalFavouredAmount = displayedStudents.fold<double>(
      0.0,
      (sum, student) => sum + student.favouredAmount,
    );
    final uniqueGroups = displayedStudents.map((s) => s.groupId).toSet().length;

    // All three cards stacked vertically
    return Column(
      children: [
        _buildNeomorphicVerticalCard(
          icon: Icons.people_rounded,
          title: 'Total Students',
          value: totalStudents.toString(),
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(height: 16),
        _buildNeomorphicVerticalCard(
          icon: Icons.account_balance_wallet_rounded,
          title: 'Total Favoured',
          value: currencyFormat.format(totalFavouredAmount),
          color: const Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 16),
        _buildNeomorphicVerticalCard(
          icon: Icons.groups_rounded,
          title: 'Active Groups',
          value: uniqueGroups.toString(),
          color: const Color(0xFF10B981),
        ),
      ],
    );
  }

  Widget _buildNeomorphicVerticalCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return _buildNeomorphicContainer(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _backgroundColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: _shadowDark,
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: _shadowLight,
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedStudentsList(
    FavouredStudentsLoadedState state,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    Map<String, List<FavouredStudentEntity>> displayGroups;

    if (state.selectedGroupId == null) {
      displayGroups = state.groupedByGroup;
    } else {
      displayGroups = {
        state.selectedGroupId!: state.groupedByGroup[state.selectedGroupId!]!,
      };
    }

    final sortedGroupIds = displayGroups.keys.toList()..sort();

    return Column(
      children:
          sortedGroupIds.asMap().entries.map((entry) {
            final index = entry.key;
            final groupId = entry.value;
            final students = displayGroups[groupId]!;

            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: _buildNeomorphicGroupSection(
                groupId,
                students,
                currencyFormat,
                isTablet,
              ),
            );
          }).toList(),
    );
  }

  Widget _buildNeomorphicGroupSection(
    String groupId,
    List<FavouredStudentEntity> students,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    final totalFavouredInGroup = students.fold<double>(
      0.0,
      (sum, student) => sum + student.favouredAmount,
    );
    final isExpanded = _expandedGroupId == groupId;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: _buildNeomorphicContainer(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // Group Header - Clickable
            InkWell(
              onTap: () {
                setState(() {
                  _expandedGroupId = isExpanded ? null : groupId;
                });
              },
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Expand/Collapse Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: _shadowDark,
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            color: _shadowLight,
                            offset: Offset(-2, -2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.expand_more_rounded,
                          color: Color(0xFF3B82F6),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Group Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                groupId,
                                style: const TextStyle(
                                  color: Color(0xFF2C3E50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: _shadowDark,
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                    ),
                                    BoxShadow(
                                      color: _shadowLight,
                                      offset: Offset(-2, -2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${students.length} ${students.length == 1 ? 'student' : 'students'}',
                                  style: const TextStyle(
                                    color: Color(0xFF3B82F6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_rounded,
                                size: 16,
                                color: Color(0xFF8B5CF6),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Total: ${currencyFormat.format(totalFavouredInGroup)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expandable Content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child:
                  isExpanded
                      ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: _buildNeomorphicStudentsTable(
                          students,
                          currencyFormat,
                          isTablet,
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeomorphicStudentsTable(
    List<FavouredStudentEntity> students,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: _buildNeomorphicInset(
        padding: const EdgeInsets.all(12),
        child: DataTable(
          columnSpacing: isTablet ? 40 : 20,
          headingRowHeight: 56,
          dataRowHeight: 72,
          headingRowColor: WidgetStateProperty.all(_backgroundColor),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          columns: [
            _buildNeomorphicDataColumn('Student Name', Icons.person_rounded),
            _buildNeomorphicDataColumn('Student ID', Icons.badge_rounded),
            _buildNeomorphicDataColumn(
              'Previous Fee',
              Icons.attach_money_rounded,
            ),
            _buildNeomorphicDataColumn('Favoured', Icons.money_off_rounded),
            _buildNeomorphicDataColumn('New Fee', Icons.payments_rounded),
            _buildNeomorphicDataColumn('Reason', Icons.description_rounded),
            _buildNeomorphicDataColumn('Date', Icons.calendar_today_rounded),
          ],
          rows:
              students.map((student) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _backgroundColor,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: _shadowDark,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                                BoxShadow(
                                  color: _shadowLight,
                                  offset: Offset(-2, -2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                student.studentName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B82F6),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            student.studentName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: _shadowDark,
                              offset: Offset(2, 2),
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              color: _shadowLight,
                              offset: Offset(-2, -2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          student.studentId,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        currencyFormat.format(student.previousTotalFee),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.2),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                            const BoxShadow(
                              color: _shadowLight,
                              offset: Offset(-2, -2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          currencyFormat.format(student.favouredAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.2),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                            ),
                            const BoxShadow(
                              color: _shadowLight,
                              offset: Offset(-2, -2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          currencyFormat.format(student.newTotalFee),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Tooltip(
                          message: student.description,
                          child: Text(
                            student.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(student.createdAt),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  DataColumn _buildNeomorphicDataColumn(String label, IconData icon) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}
