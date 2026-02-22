import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/FavouredStudentEntity%20.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_text.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/screen_header.dart';
import 'package:intl/intl.dart';

class FavouredStudentsScreen extends StatefulWidget {
  const FavouredStudentsScreen({super.key});

  @override
  State<FavouredStudentsScreen> createState() => _FavouredStudentsScreenState();
}

class _FavouredStudentsScreenState extends State<FavouredStudentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FeeAdminBloc>().add(const ReadFavouredStudentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');

    return GradientBackground(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: SafeArea(
          child: ResponsivePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScreenHeader(
                  title: 'Favoured Students',
                  trailing: IconButton(
                    onPressed: () {
                      context.read<FeeAdminBloc>().add(
                        const ReadFavouredStudentsEvent(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: BlocBuilder<FeeAdminBloc, FeeAdminState>(
                    builder: (context, state) {
                      if (state is FavouredStudentsLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is FavouredStudentsErrorState) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error loading favoured students',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.error,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is FavouredStudentsLoadedState) {
                        if (state.favouredStudents.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No favoured students yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return isTablet
                            ? _buildTabletLayout(
                              state,
                              currencyFormat,
                              isTablet,
                            )
                            : _buildMobileLayout(
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
      ),
    );
  }

  // Tablet/Desktop Layout (side-by-side with full scrollable)
  Widget _buildTabletLayout(
    FavouredStudentsLoadedState state,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left sidebar with filters and summary
          SizedBox(
            width: 320,
            child: Column(
              children: [
                _buildGroupFilter(state, context),
                const SizedBox(height: 20),
                _buildSummaryCards(state, currencyFormat),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Right content area with students list
          Expanded(
            child: _buildGroupedStudentsList(state, currencyFormat, isTablet),
          ),
        ],
      ),
    );
  }

  // Mobile Layout (stacked with full scrollable)
  Widget _buildMobileLayout(
    FavouredStudentsLoadedState state,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildGroupFilter(state, context),
          const SizedBox(height: 16),
          _buildSummaryCards(state, currencyFormat),
          const SizedBox(height: 20),
          _buildGroupedStudentsList(state, currencyFormat, isTablet),
        ],
      ),
    );
  }

  Widget _buildGroupFilter(
    FavouredStudentsLoadedState state,
    BuildContext context,
  ) {
    final groups = state.groupedByGroup.keys.toList()..sort();

    return NeuCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filter by Group',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String?>(
                value: state.selectedGroupId,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: const Text('All Groups'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.select_all,
                          size: 18,
                          color: Color(0xFF6B7280),
                        ),
                        SizedBox(width: 8),
                        Text('All Groups'),
                      ],
                    ),
                  ),
                  ...groups.map((groupId) {
                    final count = state.groupedByGroup[groupId]!.length;
                    return DropdownMenuItem<String?>(
                      value: groupId,
                      child: Row(
                        children: [
                          Icon(
                            Icons.group,
                            size: 18,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text('$groupId'),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
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

    return Column(
      children: [
        _buildSummaryCard(
          icon: Icons.people,
          title: 'Total Students',
          value: totalStudents.toString(),
          gradient: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          icon: Icons.money_off,
          title: 'Total Favoured',
          value: currencyFormat.format(totalFavouredAmount),
          gradient: [const Color(0xFF9333EA), const Color(0xFF7E22CE)],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          icon: Icons.group,
          title: 'Groups',
          value: uniqueGroups.toString(),
          gradient: [const Color(0xFF10B981), const Color(0xFF059669)],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradient,
  }) {
    return NeuCard(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradient[0].withOpacity(0.1),
              gradient[1].withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: gradient[1],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          sortedGroupIds.map((groupId) {
            final students = displayGroups[groupId]!;
            return _buildGroupSection(
              groupId,
              students,
              currencyFormat,
              isTablet,
            );
          }).toList(),
    );
  }

  Widget _buildGroupSection(
    String groupId,
    List<FavouredStudentEntity> students,
    NumberFormat currencyFormat,
    bool isTablet,
  ) {
    final totalFavouredInGroup = students.fold<double>(
      0.0,
      (sum, student) => sum + student.favouredAmount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced Group Header
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.group, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                groupId,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${students.length} student${students.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Favoured',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  Text(
                    currencyFormat.format(totalFavouredInGroup),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Students Table
        NeuCard(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: isTablet ? 50 : 24,
                headingRowHeight: 56,
                dataRowHeight: 64,
                headingRowColor: MaterialStateProperty.all(
                  const Color(0xFFF3F4F6),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Student Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Student ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Previous Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Favoured Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'New Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Reason',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
                rows:
                    students.map((student) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(
                                    0xFF3B82F6,
                                  ).withOpacity(0.1),
                                  child: Text(
                                    student.studentName[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF3B82F6),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  student.studentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                student.studentId,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              currencyFormat.format(student.previousTotalFee),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
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
                                color: const Color(0xFF9333EA).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currencyFormat.format(student.favouredAmount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9333EA),
                                  fontSize: 14,
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
                                color: const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currencyFormat.format(student.newTotalFee),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: const BoxConstraints(maxWidth: 220),
                              child: Tooltip(
                                message: student.description,
                                child: Text(
                                  student.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Color(0xFF9CA3AF),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(student.createdAt),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF6B7280),
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
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
