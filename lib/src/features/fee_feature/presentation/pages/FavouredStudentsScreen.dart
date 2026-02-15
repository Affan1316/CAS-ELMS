import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/FavouredStudentEntity%20.dart';
// import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/favoured_student_entity.dart';
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
    // Load favoured students on screen init
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

                // BLoC Consumer
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

                        return Column(
                          children: [
                            // Group Filter Dropdown
                            _buildGroupFilter(state, context),
                            const SizedBox(height: 20),

                            // Summary Cards
                            _buildSummaryCards(state, currencyFormat),
                            const SizedBox(height: 20),

                            // Students List (grouped)
                            Expanded(
                              child: _buildGroupedStudentsList(
                                state,
                                currencyFormat,
                                isTablet,
                              ),
                            ),
                          ],
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

  Widget _buildGroupFilter(
    FavouredStudentsLoadedState state,
    BuildContext context,
  ) {
    final groups = state.groupedByGroup.keys.toList()..sort();

    return NeuCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.filter_list, color: Color(0xFF3B82F6)),
            const SizedBox(width: 12),
            const Text(
              'Filter by Group:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButton<String?>(
                value: state.selectedGroupId,
                isExpanded: true,
                hint: const Text('All Groups'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Groups'),
                  ),
                  ...groups.map((groupId) {
                    final count = state.groupedByGroup[groupId]!.length;
                    return DropdownMenuItem<String?>(
                      value: groupId,
                      child: Text('$groupId ($count students)'),
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
    // Calculate totals based on selected filter
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

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.people,
            title: 'Total Students',
            value: totalStudents.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.money_off,
            title: 'Total Favoured',
            value: currencyFormat.format(totalFavouredAmount),
            color: Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.group,
            title: 'Groups',
            value: uniqueGroups.toString(),
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required MaterialColor color,
  }) {
    return NeuCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color.shade600, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color.shade700,
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
    // Get groups to display
    Map<String, List<FavouredStudentEntity>> displayGroups;

    if (state.selectedGroupId == null) {
      displayGroups = state.groupedByGroup;
    } else {
      displayGroups = {
        state.selectedGroupId!: state.groupedByGroup[state.selectedGroupId!]!,
      };
    }

    final sortedGroupIds = displayGroups.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedGroupIds.length,
      itemBuilder: (context, index) {
        final groupId = sortedGroupIds[index];
        final students = displayGroups[groupId]!;

        return _buildGroupSection(groupId, students, currencyFormat, isTablet);
      },
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
        // Group Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  groupId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${students.length} student${students.length > 1 ? 's' : ''}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Spacer(),
              Text(
                'Total: ${currencyFormat.format(totalFavouredInGroup)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ),

        // Students Table
        NeuCard(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: isTablet ? 40 : 20,
                headingRowColor: MaterialStateProperty.all(
                  Colors.grey.shade100,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Student Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Student ID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Previous Fee',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Favoured Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'New Fee',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Reason',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows:
                    students.map((student) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              student.studentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(Text(student.studentId)),
                          DataCell(
                            Text(
                              currencyFormat.format(student.previousTotalFee),
                            ),
                          ),
                          DataCell(
                            Text(
                              currencyFormat.format(student.favouredAmount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              currencyFormat.format(student.newTotalFee),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
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
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              DateFormat(
                                'MMM dd, yyyy',
                              ).format(student.createdAt),
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
