class LoginRequestModel {
  final String contactNumber;
  final String password;
  final String fcmToken;
  final String androidId;

  const LoginRequestModel({
    required this.contactNumber,
    required this.password,
    required this.fcmToken,
    required this.androidId,
  });

  Map<String, dynamic> toJson() {
    return {
      'contactNumber': contactNumber,
      'password': password,
      'FcmToken': fcmToken,
      'AndroidId': androidId,
    };
  }
}
