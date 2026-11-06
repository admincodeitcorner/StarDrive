import '../../domain/entities/passenger_ride_entity.dart';

class PassengerRideOfferModel extends PassengerOfferEntity {
  const PassengerRideOfferModel({
    required super.requestId,
    required super.driverProfileId,
    required super.driverName,
    required super.driverRating,
    required super.totalRides,
    required super.vehicleType,
    required super.vehicleNumber,
    required super.vehicleModel,
    required super.vehicleColor,
    required super.fare,
    required super.currency,
    required super.driverDistanceKm,
    required super.offeredAt,
  });

  factory PassengerRideOfferModel.fromJson(Map<String, dynamic> json) {
    return PassengerRideOfferModel(
      requestId: json['requestId'] as String,
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      driverName: json['driverName'] as String,

      // Supports both integer and decimal rating values.
      driverRating: (json['driverRating'] as num).toDouble(),

      totalRides: (json['totalRides'] as num).toInt(),
      vehicleType: json['vehicleType'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      vehicleModel: json['vehicleModel'] as String,
      vehicleColor: json['vehicleColor'] as String,
      fare: (json['fare'] as num).toInt(),
      currency: json['currency'] as String,

      // Converts integer distance values into double.
      driverDistanceKm: (json['driverDistanceKm'] as num).toDouble(),

      // Converts ISO-8601 string into DateTime.
      offeredAt: DateTime.parse(json['offeredAt'] as String),
    );
  }
}