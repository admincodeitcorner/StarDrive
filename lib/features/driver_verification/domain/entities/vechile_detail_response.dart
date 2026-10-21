import 'package:equatable/equatable.dart';

class VehicleDetails extends Equatable {
  final int id;
  final int userId;
  final int driverProfileId;

  final String vehicleNumber;
  final String manufacturer;
  final String model;
  final int year;
  final String type;
  final String color;
  final int seatingCapacity;

  final String vehiclePicPath;
  final String vehicleFrontPicPath;
  final String vehicleBackPicPath;

  final String vehicleStatus;
  final String? rejectionReason;
  final bool isDefault;
  final String driverStatus;
  final bool isApproved;

  const VehicleDetails({
    required this.id,
    required this.userId,
    required this.driverProfileId,
    required this.vehicleNumber,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.type,
    required this.color,
    required this.seatingCapacity,
    required this.vehiclePicPath,
    required this.vehicleFrontPicPath,
    required this.vehicleBackPicPath,
    required this.vehicleStatus,
    this.rejectionReason,
    required this.isDefault,
    required this.driverStatus,
    required this.isApproved,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        driverProfileId,
        vehicleNumber,
        manufacturer,
        model,
        year,
        type,
        color,
        seatingCapacity,
        vehiclePicPath,
        vehicleFrontPicPath,
        vehicleBackPicPath,
        vehicleStatus,
        rejectionReason,
        isDefault,
        driverStatus,
        isApproved,
      ];
}