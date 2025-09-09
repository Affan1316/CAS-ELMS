  // Function to generate bar chart groups
  import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/time_graph_page/data/dummy_data.dart';

List<BarChartGroupData> generateBarGroups(List<DailyStudyData> studentStudyData) {
    return studentStudyData.asMap().entries.map((entry) {
      final int index = entry.key;
      final DailyStudyData data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.hours,
            color: AppColors.primaryColor,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ],
      );
    }).toList();
  }