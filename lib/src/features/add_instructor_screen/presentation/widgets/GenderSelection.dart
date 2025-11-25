import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_bloc.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_event.dart';
import 'package:flutter_cas_app_main/src/features/add_instructor_screen/presentation/bloc/add_instructor_state.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddInstructorBloc, AddInstructorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _GenderOption(
                    gender: 'Male',
                    icon: Icons.male,
                    isSelected: state.selectedGender == 'Male',
                    onTap:
                        () => context.read<AddInstructorBloc>().add(
                          GenderChangedEvent('Male'),
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _GenderOption(
                    gender: 'Female',
                    icon: Icons.female,
                    isSelected: state.selectedGender == 'Female',
                    onTap:
                        () => context.read<AddInstructorBloc>().add(
                          GenderChangedEvent('Female'),
                        ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String gender;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.gender,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF3B82F6).withOpacity(0.1)
                  : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF6B7280),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    isSelected
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
