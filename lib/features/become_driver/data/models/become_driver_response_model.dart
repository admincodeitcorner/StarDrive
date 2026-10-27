
import 'package:star_drive/features/become_driver/domain/entity/become_driver_response_entity.dart';

class BecomeDriverResponseModel extends BecomeDriverResponseEntity{

  const BecomeDriverResponseModel({
    required super.userId,
    required super.driverProfileId,
    required super.isDriver,
    required super.driverStatus,
    super.rejectionReason,
    required super.isApproved,
    required super.token, required super.message,
  });

  factory BecomeDriverResponseModel.fromJson(
    Map<String, dynamic> json, String message
  ) {
    return BecomeDriverResponseModel(
          message: message,

      userId: (json['userId'] as num).toInt(),
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      isDriver: json['isDriver'] as bool,
      driverStatus: json['driverStatus'] as String,
      rejectionReason: json['rejectionReason'] as String?,
      isApproved: json['isApproved'] as bool,
      token: json['token'] as String,
    );
  }

  
}