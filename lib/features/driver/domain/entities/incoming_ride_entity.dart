import 'package:equatable/equatable.dart';

class IncomingRideEntity extends Equatable {
  final String requestId;
  final String vehicleType;

  final double pickupLat;
  final double pickupLon;
  final String pickupName;

  final double dropLat;
  final double dropLon;
  final String dropName;

  final double distanceKm;
  final double pickupDistanceKm;

  final int passengerOfferedFare;
  final int suggestedFare;
  final int minimumOffer;

  final String currency;
  final int secondsRemaining;

  final String passengerName;
  final double passengerRating;

  const IncomingRideEntity({
    required this.requestId,
    required this.vehicleType,
    required this.pickupLat,
    required this.pickupLon,
    required this.pickupName,
    required this.dropLat,
    required this.dropLon,
    required this.dropName,
    required this.distanceKm,
    required this.pickupDistanceKm,
    required this.passengerOfferedFare,
    required this.suggestedFare,
    required this.minimumOffer,
    required this.currency,
    required this.secondsRemaining,
    required this.passengerName,
    required this.passengerRating,
  });

  @override
  List<Object?> get props => [
        requestId,
        vehicleType,
        pickupLat,
        pickupLon,
        pickupName,
        dropLat,
        dropLon,
        dropName,
        distanceKm,
        pickupDistanceKm,
        passengerOfferedFare,
        suggestedFare,
        minimumOffer,
        currency,
        secondsRemaining,
        passengerName,
        passengerRating,
      ];
}