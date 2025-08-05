import 'package:equatable/equatable.dart';

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

class OnboardingLoginSuccess extends OnboardingState {
  final String userId;
  final String selectedRole;

  const OnboardingLoginSuccess({
    required this.userId,
    required this.selectedRole,
  });

  @override
  List<Object> get props => [userId, selectedRole];
}
