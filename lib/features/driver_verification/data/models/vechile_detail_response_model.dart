import 'package:star_drive/features/driver_verification/domain/entities/vechile_detail_response.dart';


class VehicleDetailsResponseModel extends VehicleDetails {
  const VehicleDetailsResponseModel({
    required super.id,
    required super.userId,
    required super.driverProfileId,
    required super.vehicleNumber,
    required super.manufacturer,
    required super.model,
    required super.year,
    required super.type,
    required super.color,
    required super.seatingCapacity,
    required super.vehiclePicPath,
    required super.vehicleFrontPicPath,
    required super.vehicleBackPicPath,
    required super.vehicleStatus,
    super.rejectionReason,
    required super.isDefault,
    required super.driverStatus,
    required super.isApproved,
  });

  factory VehicleDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VehicleDetailsResponseModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      model: json['model'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      color: json['color'] as String? ?? '',
      seatingCapacity: (json['seatingCapacity'] as num?)?.toInt() ?? 0,
      vehiclePicPath: json['vehiclePicPath'] as String? ?? '',
      vehicleFrontPicPath:
          json['vehicleFrontPicPath'] as String? ?? '',
      vehicleBackPicPath:
          json['vehicleBackPicPath'] as String? ?? '',
      vehicleStatus: json['vehicleStatus'] as String? ?? 'Pending',
      rejectionReason: json['rejectionReason'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      driverStatus: json['driverStatus'] as String? ?? '',
      isApproved: json['isApproved'] as bool? ?? false,
    );
  }
}