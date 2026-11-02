import '../../domain/entities/driver_availability_entity.dart';

class DriverOnlineResponseModel extends DriverAvailabilityEntity {
  const DriverOnlineResponseModel({
    required super.driverProfileId,
    required super.isOnline,
    required super.vehicleId,
    required super.vehicleType,
    required super.vehicleNumber,
  });

  factory DriverOnlineResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverOnlineResponseModel(
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      isOnline: json['isOnline'] as bool,
      vehicleId: (json['vehicleId'] as num).toInt(),
      vehicleType: json['vehicleType'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
    );
  }
}