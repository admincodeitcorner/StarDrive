import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

class SendOtpRequestModel {
  final String contactNumber;
  final String? cnic;
  final OtpPurpose purpose;

  const SendOtpRequestModel({
    required this.contactNumber,
    this.cnic,
    required this.purpose,
  });

  Map<String, dynamic> toJson() {
    return {
      'contactNumber': contactNumber,
      if (cnic != null && cnic!.trim().isNotEmpty) 'cnic': cnic,
      'purpose': switch (purpose) {
        OtpPurpose.register => 'Registration',
        OtpPurpose.forgotPassword => 'ForgotPassword',
        OtpPurpose.changePhone => 'ChangePhone',
      },
    };
  }
}