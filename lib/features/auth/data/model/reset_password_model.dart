class ResetPasswordRequestModel {
  final String contactNumber;
  final String otpCode;
  final String newPassword;
  ResetPasswordRequestModel({
    required this.contactNumber,
    required this.otpCode,
    required this.newPassword,
  });
  Map<String, dynamic> toJson() {
    return {
      "contactNumber": contactNumber,
      "otpCode": otpCode,
      "newPassword": newPassword,
    };
  }
}
