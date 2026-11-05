

import '../../domain/entities/ride_estimate_response_entity.dart';

class RideEstimateResponseModel extends RideEstimateEntity {
  const RideEstimateResponseModel({
    required super.estimateId,
    required super.expiresAt,
    required super.vehicleType,
    required super.distanceKm,
    required super.durationMin,
    required super.suggestedFare,
    required super.minimumOffer,
    required super.currency,
    required super.polyline,
    required super.polylinePrecision,
    required super.bounds,
  });

  factory RideEstimateResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final boundsJson = json['bounds'] as Map<String, dynamic>;

    return RideEstimateResponseModel(
      estimateId: json['estimateId'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      vehicleType: json['vehicleType'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationMin: (json['durationMin'] as num).toInt(),
      suggestedFare: (json['suggestedFare'] as num).toDouble(),
      minimumOffer: (json['minimumOffer'] as num).toDouble(),
      currency: json['currency'] as String,
      polyline: json['polyline'] as String,
      polylinePrecision: (json['polylinePrecision'] as num).toInt(),
      bounds: RideEstimateBoundsEntity(
        minLat: (boundsJson['minLat'] as num).toDouble(),
        minLon: (boundsJson['minLon'] as num).toDouble(),
        maxLat: (boundsJson['maxLat'] as num).toDouble(),
        maxLon: (boundsJson['maxLon'] as num).toDouble(),
      ),
    );
  }
}