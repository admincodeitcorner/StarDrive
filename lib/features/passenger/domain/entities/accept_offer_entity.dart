import 'package:equatable/equatable.dart';

class AcceptOfferResponseEntity extends Equatable {
  const AcceptOfferResponseEntity({
    required this.id,
    required this.rideRequestId,
    required this.status,
    required this.passengerId,
    required this.passengerName,
    this.passengerContactNumber,
    required this.driverProfileId,
    required this.driverUserId,
    required this.driverName,
    this.driverContactNumber,
    required this.vehicleId,
    required this.vehicleNumber,
    required this.vehicleType,
    this.vehicleModel,
    this.vehicleColor,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupName,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.dropName,
    required this.distanceKm,
    required this.fare,
    required this.acceptedAt,
    this.arrivedAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
  });

  final int id;
  final String rideRequestId;
  final String status;

  final int passengerId;
  final String passengerName;
  final String? passengerContactNumber;

  final int driverProfileId;
  final int driverUserId;
  final String driverName;
  final String? driverContactNumber;

  final int vehicleId;
  final String vehicleNumber;
  final String vehicleType;
  final String? vehicleModel;
  final String? vehicleColor;

  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupName;

  final double dropLatitude;
  final double dropLongitude;
  final String dropName;

  final double distanceKm;
  final double fare;

  final DateTime acceptedAt;
  final DateTime? arrivedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  @override
  List<Object?> get props => [
        id,
        rideRequestId,
        status,
        passengerId,
        passengerName,
        passengerContactNumber,
        driverProfileId,
        driverUserId,
        driverName,
        driverContactNumber,
        vehicleId,
        vehicleNumber,
        vehicleType,
        vehicleModel,
        vehicleColor,
        pickupLatitude,
        pickupLongitude,
        pickupName,
        dropLatitude,
        dropLongitude,
        dropName,
        distanceKm,
        fare,
        acceptedAt,
        arrivedAt,
        startedAt,
        completedAt,
        cancelledAt,
      ];
}