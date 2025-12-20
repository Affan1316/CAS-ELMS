import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/student_workshop_time_tracker/presentation/widgets/shadow_container.dart';

class AverageTimeContainer extends StatelessWidget {
  const AverageTimeContainer({super.key, required this.totalHours, required this.averageHours});
  final double totalHours;
  final double averageHours;


  @override
  Widget build(BuildContext context) {
    return  ShadowedContainer(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Weekly Total Time:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D4C5F),
                            ),
                          ),
                          Text(
                            '${totalHours.toStringAsFixed(1)} hrs',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D4C5F),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Average:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D4C5F),
                            ),
                          ),
                          Text(
                            '${averageHours.toStringAsFixed(1)} hrs',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D4C5F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
  }
}