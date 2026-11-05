import '../../domain/entities/incoming_ride_entity.dart';

class IncomingRideModel extends IncomingRideEntity {
  const IncomingRideModel({
    required super.requestId,
    required super.vehicleType,
    required super.pickupLat,
    required super.pickupLon,
    required super.pickupName,
    required super.dropLat,
    required super.dropLon,
    required super.dropName,
    required super.distanceKm,
    required super.pickupDistanceKm,
    required super.passengerOfferedFare,
    required super.suggestedFare,
    required super.minimumOffer,
    required super.currency,
    required super.secondsRemaining,
    required super.passengerName,
    required super.passengerRating,
  });

  factory IncomingRideModel.fromJson(Map<String, dynamic> json) {
    return IncomingRideModel(
      requestId: json['requestId']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',

      pickupLat: _toDouble(json['pickupLat']),
      pickupLon: _toDouble(json['pickupLon']),
      pickupName: json['pickupName']?.toString() ?? '',

      dropLat: _toDouble(json['dropLat']),
      dropLon: _toDouble(json['dropLon']),
      dropName: json['dropName']?.toString() ?? '',

      distanceKm: _toDouble(json['distanceKm']),
      pickupDistanceKm: _toDouble(json['pickupDistanceKm']),

      passengerOfferedFare: _toInt(json['passengerOfferedFare']),
      suggestedFare: _toInt(json['suggestedFare']),
      minimumOffer: _toInt(json['minimumOffer']),

      currency: json['currency']?.toString() ?? 'PKR',
      secondsRemaining: _toInt(json['secondsRemaining']),

      passengerName: json['passengerName']?.toString() ?? '',
      passengerRating: _toDouble(json['passengerRating']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}