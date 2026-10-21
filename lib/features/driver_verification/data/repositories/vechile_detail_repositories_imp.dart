import 'package:star_drive/features/driver_verification/data/datasource/vechile_detail_remote_datasource.dart';

import 'package:star_drive/features/driver_verification/data/models/vechile_detail_request_model.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_response.dart';
import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_submission.dart';

import 'package:star_drive/features/driver_verification/domain/repositories/vechile_detail_repositories.dart';

class VehicleDetailsRepositoryImpl
    implements VehicleDetailsRepository {
  final VehicleDetailsRemoteDataSource remoteDataSource;

  VehicleDetailsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<VehicleDetails> submitVehicleDetails(
    VehicleDetailsSubmission submission,
  ) async {
    final request = VehicleDetailsRequestModel.fromEntity(
      submission,
    );

    return remoteDataSource.submitVehicleDetails(request);
  }
}