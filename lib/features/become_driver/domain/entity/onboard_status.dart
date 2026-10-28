class OnboardingStep {
  final bool done;
  final List<String> missing;

  const OnboardingStep({
    required this.done,
    required this.missing,
  });
}

class OnboardingStatus {
  final String driverStatus;
  final String? rejectionReason;
  final OnboardingStep profile;
  final OnboardingStep documents;
  final OnboardingStep? vehicle;

  const OnboardingStatus({
    required this.driverStatus,
    required this.rejectionReason,
    required this.profile,
    required this.documents,
    required this.vehicle,
  });
}