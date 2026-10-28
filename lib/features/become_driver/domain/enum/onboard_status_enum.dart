import '../entity/onboard_status.dart';

enum OnboardingDestination {
  profile,
  documents,
  vehicle,
  dashboard,
}

OnboardingDestination getNextOnboardingDestination(
  OnboardingStatus status,
) {
  if (!status.profile.done) {
    return OnboardingDestination.profile;
  }

  if (!status.documents.done) {
    return OnboardingDestination.documents;
  }

  if (status.vehicle == null || !status.vehicle!.done) {
    return OnboardingDestination.vehicle;
  }

  return OnboardingDestination.dashboard;
}