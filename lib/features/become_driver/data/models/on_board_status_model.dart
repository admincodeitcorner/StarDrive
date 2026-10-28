import '../../domain/entity/onboard_status.dart';

class OnboardingStepModel extends OnboardingStep {
  const OnboardingStepModel({
    required super.done,
    required super.missing,
  });

  factory OnboardingStepModel.fromJson(Map<String, dynamic>? json) {
    return OnboardingStepModel(
      done: json?['done'] ?? false,
      missing: List<String>.from(json?['missing'] ?? const []),
    );
  }
}

class OnboardingStatusModel extends OnboardingStatus {
  const OnboardingStatusModel({
    required super.driverStatus,
    super.rejectionReason,
    required super.profile,
    required super.documents,
    super.vehicle,
  });

  
  factory OnboardingStatusModel.fromJson(Map<String, dynamic> json) {
    return OnboardingStatusModel(
      driverStatus: json['driverStatus']?.toString() ?? '',
      rejectionReason: json['rejectionReason']?.toString(),
      profile: OnboardingStepModel.fromJson(json['profile']),
      documents: OnboardingStepModel.fromJson(json['documents']),
      vehicle: json['vehicle'] == null
          ? null
          : OnboardingStepModel.fromJson(json['vehicle']),
    );
  }
}