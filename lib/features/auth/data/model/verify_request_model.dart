import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

class VerifyRequestModel {
  final String contactNumber;
  final String otpCode;
  

  VerifyRequestModel({
    required this.contactNumber,
    required this.otpCode,
    
  });
  Map<String, dynamic> toJson(){
    return {
  "contactNumber": contactNumber,
   'purpose': 'ForgotPassword',
  "code": otpCode
};
  }
}
