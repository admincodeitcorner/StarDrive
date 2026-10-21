import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_submission.dart';

import 'package:star_drive/features/driver_verification/domain/repositories/vechile_detail_repositories.dart';


class SubmitVehicleDetailsUseCase {
  final VehicleDetailsRepository repository;

  const SubmitVehicleDetailsUseCase(this.repository);

  Future<VehicleDetails> call(
    VehicleDetailsSubmission submission,
  ) {
    return repository.submitVehicleDetails(submission);
  }
}