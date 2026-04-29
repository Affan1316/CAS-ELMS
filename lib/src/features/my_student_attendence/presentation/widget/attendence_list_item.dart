// import 'package:flutter/material.dart';
// import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
// import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/status_chip.dart';

// import '../../data/model/model_classes.dart';

// /// A dedicated StatelessWidget for a single attendance row
// class AttendanceListItem extends StatelessWidget {
//   final AttendanceRecord record;

//   const AttendanceListItem({super.key, required this.record});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: AppColors.containerColor,
//       child: ListTile(
//         title: Text(
//           record.date,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: Colors.black,
//           ),
//         ),
//         subtitle: Text(record.day, style: TextStyle(color: Colors.grey[600])),
//         // Use the StatusChip to show the status
//         trailing: StatusChip(status: record.status),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/core/theme/app_colors.dart';
import 'package:flutter_cas_app_main/src/features/my_student_attendence/presentation/widget/status_chip.dart';

import '../../data/model/model_classes.dart';

/// Premium redesigned attendance list item
/// — Zero logic changes, pure UI facelift
class AttendanceListItem extends StatefulWidget {
  final AttendanceRecord record;

  const AttendanceListItem({super.key, required this.record});

  @override
  State<AttendanceListItem> createState() => _AttendanceListItemState();
}

class _AttendanceListItemState extends State<AttendanceListItem> {
  bool _pressed = false;

  // ── Status-aware palette ──────────────────────────────────────────────────
  Color _leftAccent(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFF3B6D11); // deep green
      case 'absent':
        return const Color(0xFFA32D2D); // deep red
      case 'late':
        return const Color(0xFF854F0B); // deep amber
      default:
        return const Color(0xFF5F5E5A); // neutral gray
    }
  }

  Color _dotColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFF639922);
      case 'absent':
        return const Color(0xFFE24B4A);
      case 'late':
        return const Color(0xFFBA7517);
      default:
        return const Color(0xFF888780);
    }
  }

  // ── Abbreviated day-of-week from full date string ─────────────────────────
  // Assumes record.day contains something like "Monday" — we take first 3 chars
  String get _shortDay =>
      widget.record.day.length >= 3
          ? widget.record.day.substring(0, 3).toUpperCase()
          : widget.record.day.toUpperCase();

  // ── Parse a display-friendly date number if possible ─────────────────────
  // record.date might be "2024-07-15" or "15 Jul 2024" — show just the day num
  String get _dayNumber {
    try {
      final parts = widget.record.date.split('-');

      // Handles: 29-04-2026
      if (parts.length == 3) {
        return parts[0];
      }

      return widget.record.date;
    } catch (_) {
      return widget.record.date;
    }
  }

  String get _monthLabel {
    try {
      const months = [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC',
      ];

      final parts = widget.record.date.split('-');

      // Handles: 29-04-2026
      if (parts.length == 3) {
        final monthIndex = int.parse(parts[1]) - 1;
        return months[monthIndex];
      }

      return '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.record.status.name;

    final accent = _leftAccent(status);
    final dot = _dotColor(status);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.975 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeInOut,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.containerColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDDD9D3), width: 0.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Left accent bar ───────────────────────────────────────
                  Container(width: 4, color: accent),

                  // ── Date calendar block ──────────────────────────────────
                  Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: accent.withOpacity(0.06)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayNumber,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: accent,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _monthLabel,
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            color: accent.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Main content ─────────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Day label
                                Text(
                                  widget.record.day,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1C1A17),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                // Full date as secondary line
                                Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: dot,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      widget.record.date,
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF8C8680),
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // ── Status chip — unchanged logic ────────────────
                          StatusChip(status: widget.record.status),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
