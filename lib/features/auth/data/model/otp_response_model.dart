import 'package:star_drive/features/auth/domain/entities/otp_details.dart';

class SendOtpResponseModel extends OtpDetails{

  const SendOtpResponseModel({
    required super.expiresInSeconds,
    required super.resendAfterSeconds,
    required super.devCode,
  });

  factory SendOtpResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SendOtpResponseModel(
      expiresInSeconds:
          (json['expiresInSeconds'] as num?)?.toInt() ?? 0,
      resendAfterSeconds:
          (json['resendAfterSeconds'] as num?)?.toInt() ?? 0,
      devCode: json['devCode']?.toString() ?? '',
    );
  }

  
  
}