import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/data/student_data.dart';
import 'package:intl/intl.dart';
import 'package:responsive_ui_kit/responsive_ui_kit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../bloc/time_graph_page_bloc.dart';
import '../widgets/average_time_container.dart';
import '../widgets/bar_graph_data.dart';
import '../widgets/info_card.dart';
import '../widgets/my_appbar.dart';
import '../widgets/my_choice_chip.dart';
import '../widgets/shadow_container.dart';
import '../widgets/title_text.dart';

class StudentTimeTrackerPage extends StatefulWidget {
  const StudentTimeTrackerPage({super.key});

  @override
  State<StudentTimeTrackerPage> createState() => _StudentTimeTrackerPageState();
}

typedef DummyStudent =
    ({String name, String courseName, String batchName, String rollno});

class _StudentTimeTrackerPageState extends State<StudentTimeTrackerPage> {
  DateTimeRange? _selectedDateRange;
  String selectedFilter = 'This Week';

  //TODO: add real but its dummy Student DAta
  DummyStudent studentData = (
    name: "...",
    courseName: "Flutter",
    batchName: "...",
    rollno: "...",
  );
  final double studentMaxHours = 8;

  update() async {
    getStudentData().then((value) {
      setState(() {
        value != null ? studentData = value : studentData;
      });
    });
  }

  // Add this getter method to calculate max hours
  double maxHours(List<DailyStudyData> filteredStudyData) {
    if (filteredStudyData.isEmpty) return studentMaxHours;

    double maxValue = filteredStudyData
        .map((data) => data.hours)
        .reduce((a, b) => a > b ? a : b);

    // Add some padding (10%) to the max value
    return (maxValue * 1.1).ceilToDouble().clamp(
      studentMaxHours * 0.5,
      double.infinity,
    );
  }

  // Filter options
  final Map<String, List<DailyStudyData>> _filterOptions = {
    // First 7 days (this week)
    'Last Week': studyData['Last Week']!.toList(), // Next 7 days (last week)
    'This Month': studyData['This Month']!.toList(), // All data (this month)
    'Custom': [],
  };

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Apply',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: const Color(0xFFE6E9EF),
              onSurface: const Color(0xFF3D4C5F),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      if (context.mounted) {
        context.read<TimeGraphPageBloc>().add(SelectiveRangeEvent(picked));
      }

      // setState(() {
      //   _selectedDateRange = picked;
      //   _selectedFilter = 'Custom';
      // });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TimeGraphPageBloc>().add(const ThisWeekEvent());
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E9EF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyAppbar(studentName: studentData.name),
              const SizedBox(height: 24),
              const TitleText(data: 'Student Info'),
              StudentInfoCard(student: studentData),

              // Date range selector
              const TitleText(data: 'Select Time Range'),
              const SizedBox(height: 12),
              MyChoiceChips(selectedFilter: selectedFilter),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _selectDateRange(context),
                child: ShadowedContainer(
                  // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDateRange != null
                            ? '${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}'
                            : 'Select Custom Date Range',
                        style: const TextStyle(
                          color: Color(0xFF3D4C5F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const TitleText(data: 'Study Hours'),

              // Neumorphic chart container
              SizedBox(
                height: context.height * 0.45,
                child: ShadowedContainer(
                  child: BlocConsumer<TimeGraphPageBloc, TimeGraphPageState>(
                    bloc: context.read<TimeGraphPageBloc>(),
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is TimeGraphPageLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is TimeGraphPageLoaded) {
                        var studentData = state.studentData;
                        return studentData.isNotEmpty
                            ? BarChart(
                              BarChartData(
                                borderData: FlBorderData(show: false),
                                barGroups: generateBarGroups(studentData),
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxHours(studentData),
                                minY: 0,
                                groupsSpace: 16,
                                barTouchData: BarTouchData(
                                  enabled: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipItem: (
                                      group,
                                      groupIndex,
                                      rod,
                                      rodIndex,
                                    ) {
                                      final data =
                                          state.studentData[group.x.toInt()];
                                      return BarTooltipItem(
                                        '${data.hours} hrs\n${DateFormat('MMM d').format(data.date)}',
                                        TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (
                                        double value,
                                        TitleMeta meta,
                                      ) {
                                        final index = value.toInt();
                                        if (index >= 0 &&
                                            index < studentData.length) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Text(
                                              selectedFilter == 'Custom'
                                                  ? DateFormat('MMM d').format(
                                                    state
                                                        .studentData[index]
                                                        .date,
                                                  )
                                                  : state
                                                      .studentData[index]
                                                      .day,
                                              style: const TextStyle(
                                                color: Color(0xFF3D4C5F),
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (
                                        double value,
                                        TitleMeta meta,
                                      ) {
                                        if (value == meta.min ||
                                            value == meta.max) {
                                          return const Text('');
                                        }
                                        return Text(
                                          value.toInt().toString(),
                                          style: const TextStyle(
                                            color: Color(0xFF3D4C5F),
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                      reservedSize: 28,
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval:
                                      maxHours(studentData) > 10 ? 2 : 1,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: const Color(0xFFD1D9E6),
                                      strokeWidth: 1.5,
                                    );
                                  },
                                ),
                              ),
                            )
                            : const Center(
                              child: Text(
                                'No data available for selected range',
                                style: TextStyle(
                                  color: Color(0xFF3D4C5F),
                                  fontSize: 16,
                                ),
                              ),
                            );
                      } else if (state is TimeGraphPageErrorState) {
                        return Center(child: Text(state.message));
                      } else {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Summary section
              Builder(
                builder: (context) {
                  var totalHours =
                      context.watch<TimeGraphPageBloc>().totalHours;
                  var averageHours =
                      context.watch<TimeGraphPageBloc>().averageHours;
                  return AverageTimeContainer(
                    totalHours: totalHours,
                    averageHours: averageHours,
                  );
                },
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}
