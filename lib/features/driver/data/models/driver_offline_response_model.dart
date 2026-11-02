import '../../domain/entities/driver_offline_entity.dart';

class DriverOfflineResponseModel extends DriverOfflineEntity {
  const DriverOfflineResponseModel({
    required super.driverProfileId,
    required super.isOnline,
  });

  factory DriverOfflineResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverOfflineResponseModel(
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      isOnline: json['isOnline'] as bool,
    );
  }
}