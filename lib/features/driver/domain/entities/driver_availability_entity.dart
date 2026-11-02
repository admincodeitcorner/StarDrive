class DriverAvailabilityEntity {
  final int driverProfileId;
  final bool isOnline;
  final int vehicleId;
  final String vehicleType;
  final String vehicleNumber;

  const DriverAvailabilityEntity({
    required this.driverProfileId,
    required this.isOnline,
    required this.vehicleId,
    required this.vehicleType,
    required this.vehicleNumber,
  });
}