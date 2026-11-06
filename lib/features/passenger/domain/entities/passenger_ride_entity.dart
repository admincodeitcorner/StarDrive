import 'package:equatable/equatable.dart';

class PassengerOfferEntity extends Equatable {
  final String requestId;
  final int driverProfileId;
  final String driverName;
  final double driverRating;
  final int totalRides;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleModel;
  final String vehicleColor;
  final int fare;
  final String currency;
  final double driverDistanceKm;
  final DateTime offeredAt;

  const PassengerOfferEntity({
    required this.requestId,
    required this.driverProfileId,
    required this.driverName,
    required this.driverRating,
    required this.totalRides,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.fare,
    required this.currency,
    required this.driverDistanceKm,
    required this.offeredAt,
  });

  @override
  List<Object?> get props => [
        requestId,
        driverProfileId,
        driverName,
        driverRating,
        totalRides,
        vehicleType,
        vehicleNumber,
        vehicleModel,
        vehicleColor,
        fare,
        currency,
        driverDistanceKm,
        offeredAt,
      ];
}