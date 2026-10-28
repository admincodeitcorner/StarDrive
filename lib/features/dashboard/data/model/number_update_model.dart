class UpdatePhoneNumberModel {
  final String contactNumber;
  final String otpCode;

  const UpdatePhoneNumberModel({
    required this.contactNumber,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'ContactNumber': contactNumber,
      'OtpCode': otpCode,
    };
  }
}