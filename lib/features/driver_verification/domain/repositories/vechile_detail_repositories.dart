import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_submission.dart';

abstract interface class VehicleDetailsRepository {
  Future<VehicleDetails> submitVehicleDetails(
    VehicleDetailsSubmission submission,
  );
}