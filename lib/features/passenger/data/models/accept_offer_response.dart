import '../../domain/entities/accept_offer_entity.dart';

class AcceptOfferResponseModel extends AcceptOfferResponseEntity {
  const AcceptOfferResponseModel({
    required super.id,
    required super.rideRequestId,
    required super.status,
    required super.passengerId,
    required super.passengerName,
    super.passengerContactNumber,
    required super.driverProfileId,
    required super.driverUserId,
    required super.driverName,
    super.driverContactNumber,
    required super.vehicleId,
    required super.vehicleNumber,
    required super.vehicleType,
    super.vehicleModel,
    super.vehicleColor,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.pickupName,
    required super.dropLatitude,
    required super.dropLongitude,
    required super.dropName,
    required super.distanceKm,
    required super.fare,
    required super.acceptedAt,
    super.arrivedAt,
    super.startedAt,
    super.completedAt,
    super.cancelledAt,
  });

  factory AcceptOfferResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptOfferResponseModel(
      id: json['id'],
      rideRequestId: json['rideRequestId'],
      status: json['status'],

      passengerId: json['passengerId'],
      passengerName: json['passengerName'],
      passengerContactNumber: json['passengerContactNumber'],

      driverProfileId: json['driverProfileId'],
      driverUserId: json['driverUserId'],
      driverName: json['driverName'],
      driverContactNumber: json['driverContactNumber'],

      vehicleId: json['vehicleId'],
      vehicleNumber: json['vehicleNumber'],

      vehicleType:json[ 'vehicleType'],
      vehicleModel: json[ 'vehicleModel'],
      vehicleColor: json['vehicleColor'],

      pickupLatitude: json[ 'pickupLatitude'],
      pickupLongitude: json['pickupLongitude'],
      pickupName: json['pickupName'],

      dropLatitude: json[ 'dropLatitude'],
      dropLongitude: json ['dropLongitude'],
      dropName: json ['dropName'],

      distanceKm: json ['distanceKm'],
      fare: json ['fare'],

      acceptedAt: json ['acceptedAt' ],
      arrivedAt: json ['arrivedAt'],
      startedAt: json ['startedAt' ],
      completedAt: json[ 'completedAt'],
      cancelledAt: json ['cancelledAt'] ,
    );
  }
}
