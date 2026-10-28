import '../../../domain/entity/onboard_status.dart';


abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingSuccess extends OnboardingState {
  final OnboardingStatus status;

  OnboardingSuccess(this.status);
}

class OnboardingFailure extends OnboardingState {
  final String message;

  OnboardingFailure(this.message);
}