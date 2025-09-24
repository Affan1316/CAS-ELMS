import 'package:equatable/equatable.dart';
import 'package:flutter_cas_app_main/src/features/student_feature/data/student_entity_class.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object> get props => [];
}

class OnboardingInitial extends OnboardingState {
  final int currentPage;
  final String? selectedRole;
  final List<String> selectedInterests;
  final bool shouldShake;

  const OnboardingInitial({
    this.currentPage = 0,
    this.selectedRole,
    this.selectedInterests = const [],
    this.shouldShake = false,
  });

  @override
  List<Object> get props => [
    currentPage,
    selectedRole ?? '',
    selectedInterests,
    shouldShake,
  ];
}

class ReadingStudentName extends OnboardingState {}

class ReadingStudentNameCompleted extends OnboardingState {
  final StudentEntityClass studentEntityClass;
  const ReadingStudentNameCompleted({required this.studentEntityClass});
}
