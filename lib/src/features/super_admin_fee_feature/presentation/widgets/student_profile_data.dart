import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cas_app_main/src/features/fee_feature/presentation/widgets/full_screen_image.dart';

/// Call this anywhere you have a studentId:
///
/// ```dart
/// showStudentProfileDialog(context, studentId: item["studentId"]);
/// ```
void showStudentProfileDialog(
  BuildContext context, {
  required String studentId,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) => StudentProfileDialog(studentId: studentId),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// StudentProfileDialog
// ─────────────────────────────────────────────────────────────────────────────
class StudentProfileDialog extends StatelessWidget {
  final String studentId;

  const StudentProfileDialog({super.key, required this.studentId});

  Future<Map<String, dynamic>?> _fetchStudent() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchStudent(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                snapshot.connectionState == ConnectionState.waiting
                    ? _LoadingCard(key: const ValueKey('loading'))
                    : snapshot.hasError || snapshot.data == null
                    ? _ErrorCard(
                      key: const ValueKey('error'),
                      message:
                          snapshot.hasError
                              ? 'Failed to load student.'
                              : 'Student not found.',
                    )
                    : _ProfileCard(
                      key: const ValueKey('data'),
                      studentId: studentId,
                      data: snapshot.data!,
                    ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProfileCard — main content
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final String studentId;
  final Map<String, dynamic> data;

  const _ProfileCard({super.key, required this.studentId, required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? 'Unknown';
    final group = data['group'] ?? '—';
    final email = data['email'] ?? '—';
    final phone = data['phone'] ?? '—';
    final gender = data['gender'] ?? '—';
    final fatherName = data['fatherName'] ?? '—';
    final imageUrl = data['profile_image'] ?? '—';

    // Dummy avatar — first letter of name as initials
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Group color badge
    final groupColor = _groupColor(group);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE6E8F0),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header (gradient bg with avatar) ─────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // ── Avatar ─────────────────────────────────────────────────
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  // 👇 Replace CircleAvatar with Image.network when you have imageUrl
                  child: Center(
                    child:
                        imageUrl == "—"
                            ? Text(
                              initials,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return FullScreenImage(
                                        imageBase64String: imageUrl,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                maxRadius: 42,
                                minRadius: 40,
                                backgroundImage: MemoryImage(
                                  base64Decode(imageUrl),
                                ),
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 14),

                // ── Name ───────────────────────────────────────────────────
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // ── Group badge ────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: groupColor.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: groupColor.withOpacity(0.6),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.group_rounded, size: 14, color: groupColor),
                      const SizedBox(width: 6),
                      Text(
                        group,
                        style: TextStyle(
                          color: groupColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info rows ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.badge_rounded,
                  label: 'Student ID',
                  value: studentId,
                ),
                _InfoRow(
                  icon: Icons.person_rounded,
                  label: 'Father Name',
                  value: fatherName,
                ),
                _InfoRow(
                  icon: Icons.email_rounded,
                  label: 'Email',
                  value: email,
                ),
                _InfoRow(
                  icon: Icons.phone_rounded,
                  label: 'Phone',
                  value: phone,
                ),
                _InfoRow(
                  icon: Icons.wc_rounded,
                  label: 'Gender',
                  value: gender,
                  isLast: true,
                ),
              ],
            ),
          ),

          // ── Close button ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _groupColor(String group) {
    final colors = [
      Colors.tealAccent.shade400,
      Colors.orangeAccent.shade200,
      Colors.purpleAccent.shade100,
      Colors.lightBlueAccent.shade200,
      Colors.pinkAccent.shade100,
    ];
    if (group.isEmpty) return Colors.tealAccent.shade400;
    return colors[group.codeUnitAt(0) % colors.length];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoRow
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Colors.blueGrey.shade700),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LoadingCard
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingCard extends StatelessWidget {
  const _LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E8F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.blueGrey),
          SizedBox(height: 16),
          Text(
            'Loading student...',
            style: TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ErrorCard
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E8F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 52,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700, fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
