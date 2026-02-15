import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/data/entities/FavouredStudentEntity .dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_bloc.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_event.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/bloc/fee_admin_state.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/gradient_background.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/neu_card.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/responsive_padding.dart';
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
    final isTablet = MediaQuery.of(context).size.width >= 700;
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
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () {
                      context.read<FeeAdminBloc>().add(
                        const ReadFavouredStudentsEvent(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<FeeAdminBloc, FeeAdminState>(
                    builder: (context, state) {
                      if (state is FavouredStudentsLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      if (state is FavouredStudentsErrorState) {
                        return _ErrorState(message: state.error);
                      }

                      if (state is FavouredStudentsLoadedState) {
                        if (state.favouredStudents.isEmpty) {
                          return const _EmptyState();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _GroupFilterCard(state: state),
                            const SizedBox(height: 20),
                            _SummaryRow(
                              state: state,
                              currencyFormat: currencyFormat,
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: _GroupedStudentsList(
                                state: state,
                                currencyFormat: currencyFormat,
                                isTablet: isTablet,
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
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
}

/* ----------------------------- FILTER ----------------------------- */

class _GroupFilterCard extends StatelessWidget {
  final FavouredStudentsLoadedState state;

  const _GroupFilterCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final groups = state.groupedByGroup.keys.toList()..sort();

    return NeuCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.filter_list_rounded, color: Color(0xFF3B82F6)),
            const SizedBox(width: 12),
            const Text(
              'Filter by Group',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton<String?>(
                value: state.selectedGroupId,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                hint: const Text('All Groups'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Groups'),
                  ),
                  ...groups.map(
                    (groupId) => DropdownMenuItem<String?>(
                      value: groupId,
                      child: Text(
                        '$groupId (${state.groupedByGroup[groupId]!.length})',
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  context.read<FeeAdminBloc>().add(
                    FilterFavouredStudentsByGroupEvent(groupId: value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------------------- SUMMARY ----------------------------- */

class _SummaryRow extends StatelessWidget {
  final FavouredStudentsLoadedState state;
  final NumberFormat currencyFormat;

  const _SummaryRow({required this.state, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    final students =
        state.selectedGroupId == null
            ? state.favouredStudents
            : state.groupedByGroup[state.selectedGroupId] ?? [];

    final totalStudents = students.length;
    final totalFavoured = students.fold<double>(
      0,
      (sum, s) => sum + s.favouredAmount,
    );
    final groups = students.map((e) => e.groupId).toSet().length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.people_alt_rounded,
            label: 'Students',
            value: totalStudents.toString(),
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.money_off_csred_rounded,
            label: 'Favoured',
            value: currencyFormat.format(totalFavoured),
            color: Colors.purple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            icon: Icons.groups_rounded,
            label: 'Groups',
            value: groups.toString(),
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final MaterialColor color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return NeuCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color.shade600),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* -------------------------- GROUP LIST ---------------------------- */

class _GroupedStudentsList extends StatelessWidget {
  final FavouredStudentsLoadedState state;
  final NumberFormat currencyFormat;
  final bool isTablet;

  const _GroupedStudentsList({
    required this.state,
    required this.currencyFormat,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final displayGroups =
        state.selectedGroupId == null
            ? state.groupedByGroup
            : {
              state.selectedGroupId!:
                  state.groupedByGroup[state.selectedGroupId!]!,
            };

    final groupIds = displayGroups.keys.toList()..sort();

    return ListView.builder(
      itemCount: groupIds.length,
      itemBuilder: (context, index) {
        final groupId = groupIds[index];
        final students = displayGroups[groupId]!;

        return _GroupSection(
          groupId: groupId,
          students: students,
          currencyFormat: currencyFormat,
          isTablet: isTablet,
        );
      },
    );
  }
}

/* -------------------------- GROUP CARD ---------------------------- */

class _GroupSection extends StatelessWidget {
  final String groupId;
  final List<FavouredStudentEntity> students;
  final NumberFormat currencyFormat;
  final bool isTablet;

  const _GroupSection({
    required this.groupId,
    required this.students,
    required this.currencyFormat,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final total = students.fold<double>(0, (sum, s) => sum + s.favouredAmount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  groupId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${students.length} students',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const Spacer(),
              Text(
                currencyFormat.format(total),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ),
        NeuCard(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: isTablet ? 48 : 24,
              dataRowHeight: 52,
              headingRowHeight: 48,
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columns: const [
                DataColumn(label: Text('Student')),
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Previous')),
                DataColumn(label: Text('Favoured')),
                DataColumn(label: Text('New Fee')),
                DataColumn(label: Text('Date')),
              ],
              rows:
                  students.map((s) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            s.studentName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataCell(Text(s.studentId)),
                        DataCell(
                          Text(currencyFormat.format(s.previousTotalFee)),
                        ),
                        DataCell(
                          Text(
                            currencyFormat.format(s.favouredAmount),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            currencyFormat.format(s.newTotalFee),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(DateFormat('MMM dd, yyyy').format(s.createdAt)),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/* ---------------------- STATES (EMPTY / ERROR) -------------------- */

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.info_outline_rounded, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No favoured students yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
