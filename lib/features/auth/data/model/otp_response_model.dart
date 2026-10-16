import 'package:star_drive/features/auth/domain/entities/otp_details.dart';

class SendOtpResponseModel {
  final int expiresInSeconds;
  final int resendAfterSeconds;
  final String devCode;

  const SendOtpResponseModel({
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
    required this.devCode,
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

  
  OtpDetails toEntity() {
    return OtpDetails(
      expiresInSeconds: expiresInSeconds,
      resendAfterSeconds: resendAfterSeconds,
      devCode: devCode,
    );
  }
}