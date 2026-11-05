import 'package:equatable/equatable.dart';

class RideEstimateEntity extends Equatable {
  final String estimateId;
  final DateTime expiresAt;
  final String vehicleType;
  final double distanceKm;
  final int durationMin;
  final double suggestedFare;
  final double minimumOffer;
  final String currency;
  final String polyline;
  final int polylinePrecision;
  final RideEstimateBoundsEntity bounds;

  const RideEstimateEntity({
    required this.estimateId,
    required this.expiresAt,
    required this.vehicleType,
    required this.distanceKm,
    required this.durationMin,
    required this.suggestedFare,
    required this.minimumOffer,
    required this.currency,
    required this.polyline,
    required this.polylinePrecision,
    required this.bounds,
  });

  @override
  List<Object?> get props => [
        estimateId,
        expiresAt,
        vehicleType,
        distanceKm,
        durationMin,
        suggestedFare,
        minimumOffer,
        currency,
        polyline,
        polylinePrecision,
        bounds,
      ];
}

class RideEstimateBoundsEntity extends Equatable {
  final double minLat;
  final double minLon;
  final double maxLat;
  final double maxLon;

  const RideEstimateBoundsEntity({
    required this.minLat,
    required this.minLon,
    required this.maxLat,
    required this.maxLon,
  });

  @override
  List<Object?> get props => [minLat, minLon, maxLat, maxLon];
}