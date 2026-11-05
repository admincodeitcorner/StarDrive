
import '../../domain/entities/ride_request_response_entity.dart';

class RideRequestResponseModel extends RideRequestResponseEntity {
  const RideRequestResponseModel({

    required super.requestId,
    required super.expiresInSeconds,
    required super.driversNotified,
  });

  factory RideRequestResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return RideRequestResponseModel(
      requestId: data['requestId'] ?? '',
      expiresInSeconds: data['expiresInSeconds'] ?? 0,
      driversNotified: data['driversNotified'] ?? 0,
    );
  }
}