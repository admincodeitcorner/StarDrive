import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

class VerifyApiRequestModel {
  final String contactNumber;
  final String otpCode;
  final OtpPurpose otpPurpose;

  VerifyApiRequestModel({
    required this.contactNumber,
    required this.otpCode,
    required this.otpPurpose,
  });
  Map<String, dynamic> toJson(){
    return {
  "contactNumber": contactNumber,
   'purpose': OtpPurpose ==OtpPurpose.forgotPassword
          ? 'ForgotPassword'
          : 'Register',
  "code": otpCode
};
  }
}
